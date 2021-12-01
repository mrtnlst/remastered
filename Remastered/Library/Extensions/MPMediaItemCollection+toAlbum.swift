//
//  MPMediaItemCollection+toAlbum.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    func toAlbum() -> LibraryCollection? {
        let idProperty = MPMediaItemPropertyAlbumPersistentID
        guard let id = representativeItem?.value(forProperty: idProperty) as? NSNumber,
              let title = representativeItem?.albumTitle,
              let subtitle = artist,
              let dateAdded = dateAdded
        else {
            return nil
        }
        return LibraryCollection(
            id: id.stringValue,
            title: title,
            subtitle: subtitle,
            dateAdded: dateAdded,
            lastPlayed: lastPlayed ?? Date(timeIntervalSince1970: 0),
            isFavorite: isFavorite,
            artwork: { self.artwork },
            items: {
                self.items.compactMap {
                    guard let id = $0.mediaPersistentID else { return nil }
                    return LibraryItem(
                        track: $0.albumTrackNumber,
                        title: $0.title ?? "",
                        id: id,
                        duration: $0.playbackDuration
                    )
                }
            }
        )
    }
}
