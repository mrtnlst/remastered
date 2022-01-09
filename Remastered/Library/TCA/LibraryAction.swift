//
//  LibraryAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation

enum LibraryAction: Equatable {
    case receiveCollections(Result<LibraryServiceResult, Never>)
    case libraryCategory(LibraryCategoryAction)
    case setCategoryNavigation(selection: UUID?)
    case libraryItem(LibraryItemAction)
    case setItemNavigation(selection: UUID?)
    case dismiss
    case openCollection(LibraryCollection?)
}
