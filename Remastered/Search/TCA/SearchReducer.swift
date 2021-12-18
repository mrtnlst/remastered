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
        let items = state.collections.map { LibraryItemState(item: $0, id: environment.uuid()) }
        let result = items.filter {
            $0.item.title.lowercased().contains(state.searchText.lowercased()) ||
            $0.item.subtitle.lowercased().contains(state.searchText.lowercased())
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
        if let item = state.searchResults.first(where: { $0.id == id }) {
            state.selectedItem = Identified(
                item,
                id: id
            )
        }
        return .none
        
    case let .libraryItem(action):
        return .none
    }
}
    .binding()
