//
//  SearchReducer.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import ComposableArchitecture

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, environment in
    switch action {
    case let .receiveCollections(.success(collections)):
        state.collections = collections
        return .none
        
    case .binding(\.$searchText):
        guard !state.searchText.isEmpty else {
            state.searchResults = []
            return .none
        }
        let items = state.collections.map { LibraryItemState(collection: $0, id: $0.id) }
        let result = items.filter {
            $0.collection.title.lowercased().contains(state.searchText.lowercased()) ||
            $0.collection.subtitle.lowercased().contains(state.searchText.lowercased())
        }
        state.searchResults = IdentifiedArrayOf<LibraryItemState>(uniqueElements: result)
        return .none
        
    case .binding:
        return .none
        
    case let .setItemNavigation(id):
        guard let id = id else {
            state.selectedItem = nil
            return .none
        }
        if let collection = state.searchResults.first(where: { $0.id == id }) {
            state.selectedItem = Identified(
                collection,
                id: id
            )
        } else if let collection = state.collections.first(where: { $0.id == id }) {
            state.selectedItem = Identified(
                LibraryItemState(collection: collection, id: collection.id),
                id: state.emptyNavigationLinkId
            )
        }
        return .none
        
    case let .libraryItem(action):
        return .none
    }
}
    .binding()
