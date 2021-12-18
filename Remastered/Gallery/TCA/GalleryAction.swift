//
//  GalleryAction.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation

enum GalleryAction: Equatable {
    case fetch
    case receiveCollections(result: Result<[LibraryCollection], Never>)
    case libraryCategory(action: LibraryCategoryAction)
    case libraryItem(action: LibraryItemAction)
    case setCategoryNavigation(selection: UUID?)
    case setItemNavigation(selection: UUID?)
}
