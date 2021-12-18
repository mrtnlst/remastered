//
//  GalleryReducer.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture

let galleryReducer = Reducer<GalleryState, GalleryAction, GalleryEnvironment> { state, action, environment in
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
            )
            guard !items.isEmpty else { return }
            items = type == .discover ? items.shuffled() : items
            
            let category = LibraryCategoryState(
                id: environment.uuid(),
                items: .init(
                    uniqueElements: items.map {
                        LibraryItemState(item: $0, id: environment.uuid())
                    }
                ),
                name: type.rawValue
            )
            state.categories.updateOrAppend(category)
        }
        return .none
        
    case let .setCategoryNavigation(id):
        guard let id = id else {
            state.selectedCategory = nil
            return .none
        }
        if let category = state.categories.first(where: { $0.id == id }) {
            state.selectedCategory = Identified(category, id: id)
        }
        return .none
        
    case let .setItemNavigation(id):
        guard let id = id else {
            state.selectedItem = nil
            return .none
        }
        // TODO: That's not great
        var items: [LibraryItemState] = []
        for category in state.categories {
            items.append(contentsOf: category.items)
        }
        
        if let item = items.first(where: { $0.id == id }) {
            state.selectedItem = Identified(item, id: id)
        }
        return .none
        
    case let .libraryCategory(action):
        return .none
        
    case let .libraryItem(action):
        return .none
    }
}
