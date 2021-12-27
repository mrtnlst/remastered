//
//  LibraryItem.swift
//  Remastered
//
//  Created by martin on 29.11.21.
//

import MediaPlayer

struct LibraryItem: Identifiable {
    let track: Int
    let title: String
    let artist: String?
    let id: String
    let albumID: String?
    let duration: TimeInterval
    let isCloudItem: Bool
    var artwork: () -> UIImage?

    init(track: Int, title: String, artist: String? = nil, id: String, albumID: String? = nil, duration: TimeInterval, isCloudItem: Bool = false, artwork: @escaping () -> UIImage?) {
        self.track = track
        self.title = title
        self.artist = artist
        self.id = id
        self.albumID = albumID
        self.duration = duration
        self.isCloudItem = isCloudItem
        self.artwork = artwork
    }
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
    init(track: Int, title: String, artist: String? = nil, id: String, albumID: String? = nil, duration: TimeInterval, isCloudItem: Bool = false, artwork: UIImage? = nil) {
        self.track = track
        self.title = title
        self.artist = artist
        self.id = id
        self.albumID = albumID
        self.duration = duration
        self.isCloudItem = isCloudItem
        self.artwork = { artwork }
    }
    
    static let exampleItems: [LibraryItem] = [
        LibraryItem(track: 1, title: "Very long Song that needs a line break 1", id: "ddfea1b9-918c-4674-8b84-60729fdb7ac3", duration: 178),
        LibraryItem(track: 2, title: "Song 2", id: "40fff5a3-26d7-446f-9bbb-498babaaaa91", duration: 278, isCloudItem: true),
        LibraryItem(track: 3, title: "Song 3", id: "a9ff9b84-a649-47d2-bb8f-795f86f935ee", duration: 239),
        LibraryItem(track: 4, title: "Song 4", id: "6d71466c-8dc7-4cad-a79f-fee4d197aaae", duration: 800),
        LibraryItem(track: 5, title: "Song 5", id: "942f3da1-f808-4f1c-8ec7-279fc5b56c1e", duration: 234),
        LibraryItem(track: 6, title: "Song 6", id: "4ef401c7-3eab-47cd-a0a9-f63f9df4bcc0", duration: 32)
    ]
    
    static let playlistItems: [LibraryItem] = [
        LibraryItem(track: 1, title: "Saviour", artist: "Dimension", id: "ddfea1b9-918c-4674-8b84-60729fdb7ac3", albumID: "AABB-CCDD-EEFF-QQR1", duration: 178, isCloudItem: true, artwork: UIImage(named: "Organ")),
        LibraryItem(track: 2, title: "Song 2", id: "40fff5a3-26d7-446f-9bbb-498babaaaa91", albumID: "AABB-CCDD-EEFF-QQR2", duration: 278, artwork: UIImage(named: "After Hours")),
        LibraryItem(track: 3, title: "Song 3", id: "a9ff9b84-a649-47d2-bb8f-795f86f935ee", albumID: "AABB-CCDD-EEFF-QQR3", duration: 239, artwork: UIImage(named: "It's Album Time")),
        LibraryItem(track: 4, title: "Song 4", id: "6d71466c-8dc7-4cad-a79f-fee4d197aaae", albumID: "AABB-CCDD-EEFF-QQR4", duration: 800, artwork: UIImage(named: "Mosaik")),
    
    ]
}
