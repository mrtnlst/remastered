//
//  LibraryItemAction.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation

enum LibraryItemAction: Equatable {
    case didSelectItem(id: String, type: LibraryCategoryType, position: Int? = nil)
}
