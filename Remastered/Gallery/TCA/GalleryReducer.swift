//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment>.combine(
    galleryRowReducer.forEach(
        state: \.rows,
        action: /GalleryAction.galleryRowAction(id:action:),
        environment: { _ in GalleryRowEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .fetch:
            return environment
                .fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(GalleryAction.receiveCollections)
            
        case let .receiveCollections(.success(collections)):
            var effects: [Effect<GalleryAction, Never>] = []
            GalleryCategoryType.allCases.forEach { type in
                var items = Array(
                    collections
                        .filter(type.filterValue)
                        .filter { $0.type == .album || $0.type == .playlist }
                        .sorted(by: type.sortOrder)
                )
                guard !items.isEmpty else { return }
                
                if type == .discover {
                    items.shuffle()
                    // This moves the currently selected item to the first position of discover,
                    // otherwise the `LibraryItemView` gets dismissed after a new fetch.
                    if let selectedItem = state.rows.first(where: { $0.id == type.uuid })?.selectedItem?.value,
                       let index = items.firstIndex(of: selectedItem.collection) {
                        items.move(fromOffsets: .init(arrayLiteral: index), toOffset: 0)
                    }
                }
                
                let category = LibraryCategoryState(
                    id: type.uuid,
                    items: .init(uniqueElements: items.map { LibraryItemState(collection: $0, id: $0.id) }),
                    name: type.rawValue
                )
                effects.append(
                    Effect(value: .galleryRowAction(id: type.uuid, action: .receiveCategory(category)))
                )
            }
            return .merge(effects)
            
        case .dismiss:
            var effects: [Effect<GalleryAction, Never>] = []
            let rows = state.rows.filter({ $0.selectedCategory != nil || $0.selectedItem != nil })
            rows.forEach {
                effects.append(Effect(value: .galleryRowAction(id: $0.id, action: .dismiss)))
            }
            return .merge(effects)
            
        case .galleryRowAction(_, _):
            return .none
        }
    }
)
