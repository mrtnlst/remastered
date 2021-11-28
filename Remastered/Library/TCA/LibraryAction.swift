//
//  LibraryAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation

enum LibraryAction: Equatable {
    case fetch
    case receiveLibraryItems(result: Result<[LibraryRowModel], Never>)
    case libraryCategory(id: UUID, action: LibraryCategoryAction)
}
