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
    case libraryCategory(id: UUID, action: LibraryCategoryAction)
    case libraryItem(id: UUID, action: LibraryItemAction)
    case binding(BindingAction<LibraryState>)
}
