//
//  GalleryAction.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation

enum GalleryAction: Equatable {
    case onAppear
    case didBecomeActive
    case receiveCollections(Result<GalleryServiceResult, Never>)
    case galleryRowAction(id: UUID, action: GalleryRowAction)
    case libraryItem(LibraryItemAction)
    case setItemNavigation(selection: UUID?)
    case dismiss
    case openCollection(LibraryCollection?)
}
