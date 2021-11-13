//
//  LibraryAlbum.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation

struct LibraryAlbum: Equatable, Identifiable {
    let albumTitle: String
    let artist: String
    let id: UUID = UUID()
}

extension LibraryAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(albumTitle: "Organ", artist: "Dimension"),
        LibraryAlbum(albumTitle: "Whenever You Need Somebody", artist: "Rick Astley"),
        LibraryAlbum(albumTitle: "Midnight Express", artist: "Giorgio Moroder")
    ]
}
