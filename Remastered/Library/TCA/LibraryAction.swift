//
//  LibraryAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import ComposableArchitecture

enum LibraryAction: Equatable, BindableAction {
    case fetch
    case receiveCollections(result: Result<[LibraryCollection], Never>)
    case libraryCategory(LibraryCategoryAction)
    case libraryItem(LibraryItemAction)
    case binding(BindingAction<LibraryState>)
    case setCategoryNavigation(selection: UUID?)
    case setSearchResultNavigation(selection: UUID?)
}
