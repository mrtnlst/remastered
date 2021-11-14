//
//  LibraryAlbum.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import MediaPlayer

struct LibraryAlbum: Equatable, Identifiable {
    let albumTitle: String
    let artist: String
    let id: String
    let isFavorite: Bool
    
    init(albumTitle: String, artist: String, id: String = UUID().uuidString, isFavorite: Bool = false) {
        self.albumTitle = albumTitle
        self.artist = artist
        self.id = id
        self.isFavorite = isFavorite
    }
    
    init?(with collection: MPMediaItemCollection, isFavorite: Bool = false) {
        guard let albumTitle = collection.albumTitle,
              let artist = collection.albumArtist,
              let id = collection.mediaPersistentID
        else { return nil }
        
        self.albumTitle = albumTitle
        self.artist = artist
        self.id = id
        self.isFavorite = isFavorite
    }
}

extension LibraryAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(albumTitle: "Organ", artist: "Dimension"),
        LibraryAlbum(albumTitle: "Whenever You Need Somebody", artist: "Rick Astley", isFavorite: true),
        LibraryAlbum(albumTitle: "Midnight Express", artist: "Giorgio Moroder"),
        LibraryAlbum(albumTitle: "After Hours", artist: "The Weeknd"),
        LibraryAlbum(albumTitle: "Mosaik", artist: "Camo & Krooked"),
        LibraryAlbum(albumTitle: "It's Album Time", artist: "Todd Terje")
    ]
}
