//
//  LibraryCategoryType.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import Foundation

enum LibraryCategoryType: CaseIterable {
    case playlist
    case artist
    case album
    case song
    case genre
}

// MARK: - Custom Initializer
extension LibraryCategoryType {
    init?(from uuid: UUID) {
        switch uuid {
        case LibraryCategoryType.album.uuid:
            self = .album
        case LibraryCategoryType.playlist.uuid:
            self = .playlist
        case LibraryCategoryType.artist.uuid:
            self = .artist
        case LibraryCategoryType.genre.uuid:
            self = .genre
        case LibraryCategoryType.song.uuid:
            self = .song
        default: return nil
        }
    }
}

// MARK: - Mapping
extension LibraryCategoryType {
    var serviceResult: LibraryServiceResult {
        switch self {
        case .playlist:
            return .playlists([])
        case .artist:
            return .artists([])
        case .album:
            return .albums([])
        case .song:
            return .songs([])
        case .genre:
            return .genres([])
        }
    }
}

// MARK: - Properties
extension LibraryCategoryType {
    var text: String {
        switch self {
        case .playlist:
            return "Playlists"
        case .artist:
            return "Artists"
        case .album:
            return "Albums"
        case .song:
            return "Songs"
        case .genre:
            return "Genres"
        }
    }
    
    var icon: String {
        switch self {
        case .playlist:
            return "music.note.list"
        case .artist:
            return "music.mic"
        case .album:
            return "square.stack"
        case .song:
            return "music.note"
        case .genre:
            return "guitars"
        }
    }
    
    var uuid: UUID {
        switch self {
        case .playlist:
            return UUID(uuidString: "1af55f25-882e-4bce-a1d7-0b1fc5ca03a6")!
        case .artist:
            return UUID(uuidString: "588ab3db-871d-4053-9994-b306e8cb7b49")!
        case .album:
            return UUID(uuidString: "2633b316-1167-4d7b-aa3c-3c6096d2f4f2")!
        case .song:
            return UUID(uuidString: "475ee6b2-b525-4838-bb86-d411822a88bd")!
        case .genre:
            return UUID(uuidString: "b3d03edb-ffcc-4d5c-82a6-8b1d7441c854")!
        }
    }
}
