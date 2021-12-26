//
//  LibraryCategoryType.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import Foundation

enum LibraryCategoryType: String, CaseIterable {
    case playlists = "Playlists"
    case artists = "Artists"
    case albums = "Albums"
    case songs = "Songs"
    case genres = "Genres"
}

extension LibraryCategoryType {
    var icon: String {
        switch self {
        case .playlists:
            return "music.note.list"
        case .artists:
            return "music.mic"
        case .albums:
            return "square.stack"
        case .songs:
            return "music.note"
        case .genres:
            return "guitars"
        }
    }
    
    var uuid: UUID {
        switch self {
        case .playlists:
            return UUID(uuidString: "1af55f25-882e-4bce-a1d7-0b1fc5ca03a6")!
        case .artists:
            return UUID(uuidString: "588ab3db-871d-4053-9994-b306e8cb7b49")!
        case .albums:
            return UUID(uuidString: "2633b316-1167-4d7b-aa3c-3c6096d2f4f2")!
        case .songs:
            return UUID(uuidString: "475ee6b2-b525-4838-bb86-d411822a88bd")!
        case .genres:
            return UUID(uuidString: "b3d03edb-ffcc-4d5c-82a6-8b1d7441c854")!
        }
    }
}
