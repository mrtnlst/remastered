//
//  LibraryCollection.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import MediaPlayer

struct LibraryCollection {
    let libraryId: LibraryId
    let type: LibraryCategoryType
    let title: String
    let subtitle: String
    let dateAdded: Date
    let lastPlayed: Date
    let isFavorite: Bool
    let isCloudItem: Bool
    var artwork: () -> UIImage?
    var items: () -> [LibraryItem]
    
    init?(
        type: LibraryCategoryType,
        libraryId: LibraryId,
        title: String,
        subtitle: String,
        dateAdded: Date,
        lastPlayed: Date,
        isFavorite: Bool,
        isCloudItem: Bool = false,
        artwork: @escaping () -> UIImage?,
        items: @escaping () -> [LibraryItem]
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.libraryId = libraryId
        self.dateAdded = dateAdded
        self.lastPlayed = lastPlayed
        self.isFavorite = isFavorite
        self.isCloudItem = isCloudItem
        self.artwork = artwork
        self.items = items
    }
}

extension LibraryCollection: Identifiable {
    var id: UUID { libraryId.uuid }
}

extension LibraryCollection: Equatable {
    static func == (lhs: LibraryCollection, rhs: LibraryCollection) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LibraryCollection {
    // TODO: Refactor!
    func tiledArtworks() -> [UIImage] {
        let libraryItems = items()
        var artworks: [UIImage] = []
        guard !libraryItems.isEmpty else { return [] }
        
        var uniqueElements: [LibraryItem] = []
        for element in libraryItems {
            guard uniqueElements.count < 4 else { break }
            if !uniqueElements.contains(where: { $0.album?.id.persistentId == element.album?.id.persistentId }),
               let artwork = element.artwork() {
                uniqueElements.append(element)
                artworks.append(artwork)
            }
        }
        if artworks.isEmpty {
            return []
        }
        if artworks.count < 4,
           let artwork = artworks.first {
            return [artwork]
        }
        return Array(artworks.prefix(4))
    }
}

// MARK: - Simulator
extension LibraryCollection {
    init(
        type: LibraryCategoryType,
        title: String,
        subtitle: String,
        id: String = UUID().uuidString,
        dateAdded: Date,
        lastPlayed: Date? = nil,
        isFavorite: Bool = false,
        isCloudItem: Bool = false,
        artwork: UIImage? = nil,
        items: [LibraryItem] = []
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.libraryId = LibraryId(id)!
        self.dateAdded = dateAdded
        self.lastPlayed = lastPlayed ?? .init(timeIntervalSince1970: 0)
        self.isFavorite = isFavorite
        self.isCloudItem = isCloudItem
        self.artwork = { artwork }
        self.items = { items }
    }
}

extension LibraryCollection {
    static let examplePlaylists: [LibraryCollection] = [
        LibraryCollection(
            type: .playlist,
            title: "Disco Hits with an ultra long title that creates a line break",
            subtitle: "\(LibraryItem.playlistItems.count) songs",
            id: "AABB-CCDD-EEFF-QQRR",
            dateAdded: Date(timeIntervalSince1970: 1633609912),
            lastPlayed: Date(timeIntervalSince1970: 1610026199),
            isCloudItem: true,
            artwork: nil,
            items: LibraryItem.playlistItems
        )
    ]
    
    static let exampleArtists: [LibraryCollection] = [
        LibraryCollection(
            type: .artist,
            title: "The Weeknd",
            subtitle: "\(LibraryItem.playlistItems.count) songs",
            id: "AABB-CCDD-EEFF-QQBDG",
            dateAdded: Date(timeIntervalSince1970: 1615037320),
            lastPlayed: Date(timeIntervalSince1970: 1616678920),
            isFavorite: false,
            isCloudItem: true,
            artwork: UIImage(named: "After Hours"),
            items: LibraryItem.exampleItems
        )
    ]
    
    static let exampleGenres: [LibraryCollection] = [
        LibraryCollection(
            type: .genre,
            title: "Pop",
            subtitle: "\(LibraryItem.playlistItems.count) songs",
            id: "AABB-CCDD-EEFF-QQBDM",
            dateAdded: Date(timeIntervalSince1970: 1615037320),
            lastPlayed: Date(timeIntervalSince1970: 1616678920),
            isFavorite: false,
            isCloudItem: false,
            artwork: nil,
            items: LibraryItem.exampleItems
        )
    ]
    
    static let exampleAlbums: [LibraryCollection] = [
        LibraryCollection(
            type: .album,
            title: "Organ",
            subtitle: "Dimension",
            id: "AABB-CCDD-EEFF-GGHH",
            dateAdded: Date(timeIntervalSince1970: 1615037320),
            lastPlayed: Date(timeIntervalSince1970: 1616678920),
            isFavorite: true,
            artwork: UIImage(named: "Organ"),
            items: LibraryItem.exampleItems
        ),
        LibraryCollection(
            type: .album,
            title: "Whenever You Need Somebody",
            subtitle: "Rick Astley",
            id: "AABB-CCDD-EEFF-KKLL",
            dateAdded: Date(timeIntervalSince1970: 1615642120),
            artwork: UIImage(named: "Whenever You Need Somebody"),
            items: LibraryItem.exampleItems
        ),
        LibraryCollection(
            type: .album,
            title: "Midnight Express",
            subtitle: "Giorgio Moroder",
            id: "AABB-CCDD-EEFF-LLMM",
            dateAdded: Date(timeIntervalSince1970: 1615642122),
            artwork: UIImage(named: "Midnight Express"),
            items: LibraryItem.exampleItems
        ),
        LibraryCollection(
            type: .album,
            title: "After Hours",
            subtitle: "The Weeknd",
            id: "AABB-CCDD-EEFF-MMNN",
            dateAdded: Date(timeIntervalSince1970: 1632227320),
            lastPlayed: Date(timeIntervalSince1970: 1636896520),
            artwork: UIImage(named: "After Hours"),
            items: LibraryItem.exampleItems
        ),
        LibraryCollection(
            type: .album,
            title: "Mosaik",
            subtitle: "Camo & Krooked",
            id: "AABB-CCDD-EEFF-NNOO",
            dateAdded: Date(timeIntervalSince1970: 1602073720),
            lastPlayed: Date(timeIntervalSince1970: 1631276920),
            artwork: UIImage(named: "Mosaik"),
            items: LibraryItem.exampleItems
        ),
        LibraryCollection(
            type: .album,
            title: "It's Album Time",
            subtitle: "Todd Terje",
            id: "AABB-CCDD-EEFF-OOPP",
            dateAdded: Date(timeIntervalSince1970: 1633609720),
            lastPlayed: Date(timeIntervalSince1970: 1610026120),
            artwork: UIImage(named: "It's Album Time"),
            items: LibraryItem.exampleItems
        )
    ]
}
