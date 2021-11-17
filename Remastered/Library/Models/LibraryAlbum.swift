//
//  LibraryAlbum.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import MediaPlayer

struct LibraryAlbum: Equatable, Identifiable {
    let title: String
    let artist: String
    let id: String
    var position: Int?
    
    var isFavorite: Bool {
        return position != nil
    }
    
    init(title: String, artist: String, id: String = UUID().uuidString, position: Int? = nil) {
        self.title = title
        self.artist = artist
        self.id = id
        self.position = position
    }
    
    init?(with collection: MPMediaItemCollection, position: Int? = nil) {
        guard let albumTitle = collection.albumTitle,
              let artist = collection.albumArtist,
              let id = collection.mediaPersistentID
        else { return nil }
        
        self.title = albumTitle
        self.artist = artist
        self.id = id
        self.position = position
    }
}

extension LibraryAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(title: "Organ", artist: "Dimension", id: "AABB-CCDD-EEFF-GGHH"),
        LibraryAlbum(title: "Whenever You Need Somebody", artist: "Rick Astley", id: "AABB-CCDD-EEFF-KKLL", position: 0),
        LibraryAlbum(title: "Midnight Express", artist: "Giorgio Moroder", id: "AABB-CCDD-EEFF-LLMM"),
        LibraryAlbum(title: "After Hours", artist: "The Weeknd", id: "AABB-CCDD-EEFF-MMNN"),
        LibraryAlbum(title: "Mosaik", artist: "Camo & Krooked", id: "AABB-CCDD-EEFF-NNOO"),
        LibraryAlbum(title: "It's Album Time", artist: "Todd Terje", id: "AABB-CCDD-EEFF-OOPP")
    ]
}
