//
//  LibraryReducer.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import ComposableArchitecture

let libraryReducer = Reducer<LibraryState, LibraryAction, LibraryEnvironment> { state, action, environment in
    switch action {
    case let .receiveCollections(.success(result)):
        let type = result.categoryType
        let collections = result.collections
        
        let itemStates: [LibraryItemState] = collections.map { collection in
            LibraryItemState(
                collection: collection,
                id: collection.id
            )
        }
        state.categories[id: type.uuid]?.items = .init(uniqueElements: itemStates)
        if let category = state.categories[id: type.uuid] {
            state.selectedCategory = Identified(category, id: type.uuid)
        }
        return .none
        
    case let .setCategoryNavigation(id):
        guard let id = id,
              let type = LibraryCategoryType(from: id) else {
            state.selectedCategory = nil
            return .none
        }
        return environment
            .fetch(type.serviceResult)
            .receive(on: environment.mainQueue)
            .catchToEffect(LibraryAction.receiveCollections)
        
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
