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
}
