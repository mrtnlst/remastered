//
//  LibraryServiceResult.swift
//  Remastered
//
//  Created by martin on 08.01.22.
//

import Foundation

enum LibraryServiceResult: Equatable {
    case playlists([LibraryCollection])
    case artists([LibraryCollection])
    case albums([LibraryCollection])
    case songs([LibraryCollection])
    case genres([LibraryCollection])
}

extension LibraryServiceResult {
    var categoryType: LibraryCategoryType {
        switch self {
        case .playlists:
            return .playlist
        case .artists:
            return .artist
        case .albums:
            return .album
        case .songs:
            return .song
        case .genres:
            return .genre
        }
    }
    
    var collections: [LibraryCollection] {
        switch self {
        case .playlists(let array),
             .artists(let array),
             .albums(let array),
             .songs(let array),
             .genres(let array):
            return array
        }
    }
}
