//
//  LibraryItem.swift
//  Remastered
//
//  Created by martin on 29.11.21.
//

import MediaPlayer

struct LibraryItem {
    let libraryId: LibraryId
    let album: LibraryAlbum?
    let artist: LibraryArtist?
    let track: Int
    let title: String
    let duration: TimeInterval
    let isCloudItem: Bool
    var artwork: () -> UIImage?

    init(
        libraryId: LibraryId,
        album: LibraryAlbum? = nil,
        artist: LibraryArtist? = nil,
        track: Int,
        title: String,
        duration: TimeInterval,
        isCloudItem: Bool = false,
        artwork: @escaping () -> UIImage?
    ) {
        self.libraryId = libraryId
        self.track = track
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.isCloudItem = isCloudItem
        self.artwork = artwork
    }
}

extension LibraryItem: Identifiable {
    var id: UUID { libraryId.uuid }
}

extension LibraryItem: Equatable {
    static func == (lhs: LibraryItem, rhs: LibraryItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LibraryItem {
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = duration < 60 ? [.minute, .second] : [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = duration < 60 ? .dropTrailing : .default
        return formatter.string(from: duration) ?? ""
    }
}

// MARK: - Simulator

extension LibraryItem {
    init(
        libraryId: LibraryId,
        album: LibraryAlbum? = nil,
        artist: LibraryArtist? = nil,
        track: Int,
        title: String,
        duration: TimeInterval,
        isCloudItem: Bool = false,
        artwork: UIImage? = nil
    ) {
        self.libraryId = libraryId
        self.track = track
        self.title = title
        self.artist = artist
        self.album = album
        self.duration = duration
        self.isCloudItem = isCloudItem
        self.artwork = { artwork }
    }
    
    static let exampleItems: [LibraryItem] = [
        LibraryItem(
            libraryId: LibraryId("ddfea1b9-918c-4674-8b84-60729fdb7ac3")!,
            track: 1,
            title: "Very long Song that needs a line break 1",
            duration: 178
        ),
        LibraryItem(
            libraryId: LibraryId("40fff5a3-26d7-446f-9bbb-498babaaaa91")!,
            track: 2,
            title: "Song 2",
            duration: 278,
            isCloudItem: true
        ),
        LibraryItem(
            libraryId: LibraryId("a9ff9b84-a649-47d2-bb8f-795f86f935ee")!,
            track: 3,
            title: "Song 3",
            duration: 239)
        ,
        LibraryItem(
            libraryId: LibraryId("6d71466c-8dc7-4cad-a79f-fee4d197aaae")!,
            track: 4,
            title: "Song 4",
            duration: 800)
        ,
        LibraryItem(
            libraryId: LibraryId("942f3da1-f808-4f1c-8ec7-279fc5b56c1e")!,
            track: 5,
            title: "Song 5",
            duration: 234)
        ,
        LibraryItem(
            libraryId: LibraryId("4ef401c7-3eab-47cd-a0a9-f63f9df4bcc0")!,
            track: 6,
            title: "Song 6",
            duration: 32
        )
    ]
    
    static let playlistItems: [LibraryItem] = [
        LibraryItem(
            libraryId: LibraryId("ddfea1b9-918c-4674-8b84-60729fdb7ac3")!,
            album: LibraryAlbum(id: LibraryId("AABB-CCDD-EEFF-GGHH")!, title: "Organ"),
            artist: .init(id: LibraryId("AABB-CCDD")!, name: "Dimension"),
            track: 1,
            title: "Saviour",
            duration: 178,
            isCloudItem: true,
            artwork: UIImage(named: "Organ")
        ),
        LibraryItem(
            libraryId: LibraryId("40fff5a3-26d7-446f-9bbb-498babaaaa91")!,
            album: LibraryAlbum(id: LibraryId("AABB-CCDD-EEFF-QQR2")!, title: "After Hours"),
            artist: .init(id: LibraryId("AABB-CCFF")!, name: "The Weeknd"),
            track: 2,
            title: "Song 2",
            duration: 278,
            artwork: UIImage(named: "After Hours")
        ),
        LibraryItem(
            libraryId: LibraryId("a9ff9b84-a649-47d2-bb8f-795f86f935ee")!,
            album: LibraryAlbum(id: LibraryId("AABB-CCDD-EEFF-QQR3")!, title: "It's Album Time"),
            artist: .init(id: LibraryId("AABB-CCGG")!, name: "Todd Terje"),
            track: 3,
            title: "Song 3",
            duration: 239,
            artwork: UIImage(named: "It's Album Time")
        ),
        LibraryItem(
            libraryId: LibraryId("6d71466c-8dc7-4cad-a79f-fee4d197aaae")!,
            album: LibraryAlbum(id: LibraryId("AABB-CCDD-EEFF-QQR4")!, title: "Mosaik"),
            artist: .init(id: LibraryId("AABB-CCEE")!, name: "Camo & Krooked"),
            track: 4,
            title: "Song 4",
            duration: 800,
            artwork: UIImage(named: "Mosaik")
        ),
    
    ]
}
