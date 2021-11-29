//
//  LibraryItem.swift
//  Remastered
//
//  Created by martin on 29.11.21.
//

import MediaPlayer

struct LibraryItem: Equatable, Identifiable {
    let track: Int
    let title: String
    let id: String
    let duration: TimeInterval
    
    init?(with item: MPMediaItem) {
        guard let id = item.mediaPersistentID
        else { return nil }
        self.id = id
        self.track = item.albumTrackNumber
        self.title = item.title ?? ""
        self.duration = item.playbackDuration
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
        track: Int,
        title: String,
        id: String,
        duration: TimeInterval
    ) {
        self.track = track
        self.title = title
        self.id = id
        self.duration = duration
    }
}

extension LibraryItem {
    static let exampleItems: [LibraryItem] = [
        LibraryItem(track: 1, title: "Very long Song that needs a line break 1", id: "ddfea1b9-918c-4674-8b84-60729fdb7ac3", duration: 178),
        LibraryItem(track: 2, title: "Song 2", id: "40fff5a3-26d7-446f-9bbb-498babaaaa91", duration: 278),
        LibraryItem(track: 3, title: "Song 3", id: "a9ff9b84-a649-47d2-bb8f-795f86f935ee", duration: 239),
        LibraryItem(track: 4, title: "Song 4", id: "6d71466c-8dc7-4cad-a79f-fee4d197aaae", duration: 800),
        LibraryItem(track: 5, title: "Song 5", id: "942f3da1-f808-4f1c-8ec7-279fc5b56c1e", duration: 234),
        LibraryItem(track: 6, title: "Song 6", id: "4ef401c7-3eab-47cd-a0a9-f63f9df4bcc0", duration: 32),
    ]
}
