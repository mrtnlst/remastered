//
//  SearchAction.swift
//  Remastered
//
//  Created by martin on 18.12.21.
//

import ComposableArchitecture

enum SearchAction: Equatable, BindableAction {
    case receiveCollections(result: Result<[LibraryServiceResult], Never>)
    case libraryItem(LibraryItemAction)
    case binding(BindingAction<SearchState>)
    case setItemNavigation(selection: UUID?)
    case dismiss
    case openCollection(LibraryCollection?)
}
