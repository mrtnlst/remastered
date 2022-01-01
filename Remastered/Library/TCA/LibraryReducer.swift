//
//  LibraryReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let libraryReducer = Reducer<LibraryState, LibraryAction, LibraryEnvironment> { state, action, environment in
    switch action {
    case .fetch:
        return environment
            .fetch()
            .receive(on: environment.mainQueue)
            .catchToEffect(LibraryAction.receiveCollections)
        
    case let .receiveCollections(.success(collections)):
        LibraryCategoryType.allCases.forEach { type in
            let filteredCollections = collections.filter { $0.type == type }
            guard !filteredCollections.isEmpty else { return }
            
            let itemStates: [LibraryItemState] = filteredCollections.map { collection in
                LibraryItemState(
                    collection: collection,
                    id: collection.id
                )
            }
            state.categories[id: type.uuid]?.items = .init(uniqueElements: itemStates)
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
        if let item = state.categories[id: LibraryCategoryType.album.uuid]?.items.first(where: { $0.id == id }) {
            state.selectedItem = Identified(item, id: state.emptyNavigationLinkId)
        }
        return .none
        
    case .dismiss:
        state.selectedItem = nil
        state.selectedCategory = nil
        return .none
        
    case .libraryCategory(_):
        return .none
        
    case .libraryItem(_):
        return .none
    }
}
