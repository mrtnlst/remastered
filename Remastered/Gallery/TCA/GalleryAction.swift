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
    case galleryRowAction(id: UUID, action: GalleryRowAction)
    case libraryItem(LibraryItemAction)
    case setItemNavigation(selection: UUID?)
    case dismiss
}
