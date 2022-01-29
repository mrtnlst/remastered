//
//  SearchReducer.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import ComposableArchitecture

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, environment in
    switch action {
    case let .receiveCollections(.success(result)):
        let sections = result.compactMap { result -> SearchState.Section? in
            guard !result.collections.isEmpty else { return nil }
            return SearchState.Section(
                type: result.categoryType,
                items: .init(uniqueElements: result.collections.map { LibraryItemState(collection: $0, id: $0.id) })
            )
        }
        state.searchSections = .init(uniqueElements: sections)
        return .none
        
    case .binding(\.$searchText):
        guard !state.searchText.isEmpty, state.searchText.count > 2 else {
            state.searchSections = []
            return .none
        }
        return environment
            .fetch(state.searchText)
            .receive(on: environment.mainQueue)
            .catchToEffect(SearchAction.receiveCollections)
         
    case let .setItemNavigation(id):
        guard let id = id else {
            state.selectedItem = nil
            return .none
        }
        let itemStates = state.searchSections.map { $0.items }.reduce([], +)
        if let itemState = itemStates.first(where: { $0.id == id }) {
            state.selectedItem = Identified(
                itemState,
                id: id
            )
        }
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
        return .none
        
    case .binding:
        return .none
       
    case let .libraryItem(action):
        return .none
    }
}
    .binding()
