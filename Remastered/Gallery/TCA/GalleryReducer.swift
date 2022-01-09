//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import UIKit
import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment>.combine(
    galleryRowReducer.forEach(
        state: \.rows,
        action: /GalleryAction.galleryRowAction(id:action:),
        environment: { _ in GalleryRowEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
#if targetEnvironment(simulator)
            return Effect(value: .didBecomeActive)
#else
            return NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in .didBecomeActive }
                .eraseToEffect()
#endif
            
        case .didBecomeActive:
            let effects = GalleryCategoryType.allCases.map {
                environment.fetch($0.serviceResult)
                    .receive(on: environment.mainQueue)
                    .catchToEffect(GalleryAction.receiveCollections)
            }
            return .concatenate(effects)
            
        case let .receiveCollections(.success(result)):
            let type = result.categoryType
            var collections = result.collections
            
            // This moves the currently selected item to the first position of discover,
            // otherwise the `LibraryItemView` gets dismissed after a new fetch.
            if type == .discover,
               let selectedItem = state.rows[id: GalleryCategoryType.discover.uuid]?.selectedItem?.value {
                if let index = collections.firstIndex(of: selectedItem.collection) {
                    collections.move(fromOffsets: .init(arrayLiteral: index), toOffset: 0)
                } else {
                    collections.insert(selectedItem.collection, at: 0)
                }
            }
            let category = LibraryCategoryState(
                id: type.uuid,
                items: .init(uniqueElements: collections.map { LibraryItemState(collection: $0, id: $0.id) }),
                name: type.rawValue
            )
            return Effect(value: .galleryRowAction(id: type.uuid, action: .receiveCategory(category)))

        case .dismiss:
            state.selectedItem = nil
            
            var effects: [Effect<GalleryAction, Never>] = []
            let rows = state.rows.filter({ $0.selectedCategory != nil || $0.selectedItem != nil })
            rows.forEach {
                effects.append(Effect(value: .galleryRowAction(id: $0.id, action: .dismiss)))
            }
            return .merge(effects)
            
        case let .setItemNavigation(id):
            // Selected items are only set via `.openCollection`.
            state.selectedItem = nil
            return .none

        case let .openCollection(collection):
            guard let collection = collection else {
                state.selectedItem = nil
                return .none
            }
            let itemState = LibraryItemState(collection: collection, id: collection.id)
            state.selectedItem = Identified(itemState, id: state.emptyNavigationLinkId)
            return .none
            
        case .galleryRowAction(_, _):
            return .none
            
        case .libraryItem(_):
            return .none
        }
    }
)
