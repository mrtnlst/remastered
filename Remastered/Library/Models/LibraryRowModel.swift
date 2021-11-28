//
//  LibraryRowModel.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryRowModel: Identifiable, Equatable {
    enum RowType: String, CaseIterable {
        case playlists = "Playlists"
        case artists = "Artists"
        case albums = "Albums"
        case songs = "Songs"
        case genres = "Genres"
    }
    
    var type: RowType
    var items: [LibraryCollection] = []
    var id: UUID = UUID()
}


extension LibraryRowModel.RowType {
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

extension LibraryRowModel {
    static let exampleRowModels: [LibraryRowModel] = [
        LibraryRowModel(
            type: .playlists,
            items: LibraryCollection.exampleAlbums
        ),
        LibraryRowModel(
            type: .artists,
            items: LibraryCollection.exampleAlbums
        ),
        LibraryRowModel(
            type: .albums,
            items: LibraryCollection.exampleAlbums
        ),
        LibraryRowModel(
            type: .songs,
            items: LibraryCollection.exampleAlbums
        ),
        LibraryRowModel(
            type: .genres,
            items: LibraryCollection.exampleAlbums
        )
    ]
    
    static let exampleCategories: IdentifiedArrayOf<LibraryCategoryState> = [
        LibraryCategoryState(
            items: exampleItems,
            type: .playlists
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .artists
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .albums
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .songs
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .genres
        ),
    ]
    
    static let exampleItems: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            item: LibraryCollection.exampleAlbums.first!
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums.last!
        )
    ]
}
