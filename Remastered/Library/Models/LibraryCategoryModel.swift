//
//  LibraryCategoryModel.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryCategoryModel: Identifiable, Equatable {
    enum CategoryType: String, CaseIterable {
        case playlists = "Playlists"
        case artists = "Artists"
        case albums = "Albums"
        case songs = "Songs"
        case genres = "Genres"
    }
    
    var type: CategoryType
    var items: [LibraryCollection] = []
    var id: UUID = UUID()
}


extension LibraryCategoryModel.CategoryType {
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
