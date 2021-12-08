//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment>.combine (
    galleryCategoryReducer.forEach(
        state: \.categories,
        action: /GalleryAction.galleryCategory(id:action:),
        environment: { _ in GalleryCategoryEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .fetch:
            return environment
                .fetch()
                .receive(on: environment.mainQueue)
                .catchToEffect(GalleryAction.receiveCollections)
            
        case let .receiveCollections(.success(collections)):
            GalleryCategoryType.allCases.forEach { type in
                var items = Array(
                    collections
                        .filter(type.filterValue)
                        .filter { $0.type == .albums || $0.type == .playlists }
                        .sorted(by: type.sortOrder)
                        .prefix(30)
                )
                guard !items.isEmpty else { return }
                items = type == .discover ? items.shuffled() : items
                
                let category = GalleryCategoryState(
                    items: .init(
                        uniqueElements: items.map {
                            LibraryItemState(item: $0, id: environment.uuid())
                        }
                    ),
                    type: type,
                    id: environment.uuid()
                )
                state.categories.updateOrAppend(category)
            }
            return .none
        
        case .galleryCategory(_, _):
            return .none
        }
    }
)
