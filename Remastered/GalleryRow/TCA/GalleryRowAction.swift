//
//  GallerRowAction.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import Foundation

enum GalleryRowAction: Equatable {
    case libraryCategory(action: LibraryCategoryAction)
    case libraryItem(action: LibraryItemAction)
    case setCategoryNavigation(selection: UUID?)
    case setItemNavigation(selection: UUID?)
    case receiveCategory(LibraryCategoryState)
    case dismiss
}
