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
    
    init(albumTitle: String, artist: String, id: String = UUID().uuidString) {
        self.albumTitle = albumTitle
        self.artist = artist
        self.id = id
    }
    
    init?(with collection: MPMediaItemCollection) {
        guard let albumTitle = collection.albumTitle,
              let artist = collection.albumArtist,
              let id = collection.mediaPersistentID
        else { return nil }
        
        self.albumTitle = albumTitle
        self.artist = artist
        self.id = id
    }
}

extension LibraryAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(albumTitle: "Organ", artist: "Dimension"),
        LibraryAlbum(albumTitle: "Whenever You Need Somebody", artist: "Rick Astley"),
        LibraryAlbum(albumTitle: "Midnight Express", artist: "Giorgio Moroder")
    ]
}
