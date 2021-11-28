//
//  LibraryCategoryAction.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation

enum LibraryCategoryAction: Equatable {
    case libraryItem(id: UUID, action: LibraryItemAction)
}
