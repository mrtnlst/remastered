//
//  GalleryAction.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation

enum GalleryAction: Equatable {
    case fetchAlbums
    case receiveAlbums(result: Result<[LibraryAlbum], Never>)
    case didSelectItem(id: String)
}
