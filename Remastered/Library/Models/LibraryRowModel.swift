//
//  LibraryRowModel.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation

struct LibraryRowModel: Identifiable, Equatable {
    enum RowType: String, CaseIterable {
        case playlists = "Playlists"
        case artists = "Artists"
        case albums = "Albums"
        case songs = "Songs"
        case genres = "Genres"
    }
    
    var type: RowType
    var items: [LibraryAlbum] = []
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
            items: LibraryAlbum.exampleAlbums
        ),
        LibraryRowModel(
            type: .artists,
            items: LibraryAlbum.exampleAlbums
        ),
        LibraryRowModel(
            type: .albums,
            items: LibraryAlbum.exampleAlbums
        ),
        LibraryRowModel(
            type: .songs,
            items: LibraryAlbum.exampleAlbums
        ),
        LibraryRowModel(
            type: .genres,
            items: LibraryAlbum.exampleAlbums
        )
    ]
}
