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
    let dateAdded: Date
    let lastPlayed: Date
    let isFavorite: Bool
    let artwork: UIImage?
    
    init(title: String, artist: String, id: String = UUID().uuidString, dateAdded: Date, lastPlayed: Date? = nil, isFavorite: Bool = false, artwork: UIImage? = nil) {
        self.title = title
        self.artist = artist
        self.id = id
        self.dateAdded = dateAdded
        self.lastPlayed = lastPlayed ?? .init(timeIntervalSince1970: 0)
        self.isFavorite = isFavorite
        self.artwork = artwork
    }
    
    init?(with collection: MPMediaItemCollection) {
        guard let albumTitle = collection.albumTitle,
              let artist = collection.albumArtist,
              let id = collection.mediaPersistentID,
              let dateAdded = collection.dateAdded
        else { return nil }
        
        self.title = albumTitle
        self.artist = artist
        self.id = id
        self.lastPlayed = collection.lastPlayed ?? Date(timeIntervalSince1970: 0)
        self.dateAdded = dateAdded
        self.isFavorite = collection.isFavorite
        self.artwork = collection.artwork
    }
}

extension LibraryAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(title: "Organ", artist: "Dimension", id: "AABB-CCDD-EEFF-GGHH", dateAdded: Date(timeIntervalSince1970: 1615037320), lastPlayed: Date(timeIntervalSince1970: 1616678920), isFavorite: true, artwork: UIImage(named: "Organ")),
        LibraryAlbum(title: "Whenever You Need Somebody", artist: "Rick Astley", id: "AABB-CCDD-EEFF-KKLL", dateAdded: Date(timeIntervalSince1970: 1615642120), artwork: UIImage(named: "Whenever You Need Somebody")),
        LibraryAlbum(title: "Midnight Express", artist: "Giorgio Moroder", id: "AABB-CCDD-EEFF-LLMM", dateAdded: Date(timeIntervalSince1970: 1615642122), artwork: UIImage(named: "Midnight Express")),
        LibraryAlbum(title: "After Hours", artist: "The Weeknd", id: "AABB-CCDD-EEFF-MMNN", dateAdded: Date(timeIntervalSince1970: 1632227320), lastPlayed: Date(timeIntervalSince1970: 1636896520), artwork: UIImage(named: "After Hours")),
        LibraryAlbum(title: "Mosaik", artist: "Camo & Krooked", id: "AABB-CCDD-EEFF-NNOO", dateAdded: Date(timeIntervalSince1970: 1602073720), lastPlayed: Date(timeIntervalSince1970: 1631276920), artwork: UIImage(named: "Mosaik")),
        LibraryAlbum(title: "It's Album Time", artist: "Todd Terje", id: "AABB-CCDD-EEFF-OOPP", dateAdded: Date(timeIntervalSince1970: 1633609720), lastPlayed: Date(timeIntervalSince1970: 1610026120), artwork: UIImage(named: "It's Album Time"))
    ]
}
