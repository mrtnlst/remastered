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
    case didSelectItem(id: String)
}
