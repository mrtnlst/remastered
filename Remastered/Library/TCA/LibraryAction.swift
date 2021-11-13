//
//  LibraryAction.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation

enum LibraryAction: Equatable {
    case fetchAlbums
    case receiveAlbums(result: Result<[LibraryAlbum], LibraryError>)
}
