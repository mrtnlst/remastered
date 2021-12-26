//
//  MPMediaItemCollection+toArtist.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    func toArtist() -> LibraryCollection? {
        let idProperty = MPMediaItemPropertyArtistPersistentID
        guard let id = representativeItem?.value(forProperty: idProperty) as? NSNumber,
              let uuid = UUID.customUUID(from: id.stringValue),
              let title = artist,
              let dateAdded = dateAdded
        else {
            return nil
        }
        return LibraryCollection(
            type: .artists,
            id: uuid,
            persistentID: id.stringValue,
            title: title,
            subtitle: numberOfItems,
            dateAdded: dateAdded,
            lastPlayed: lastPlayed ?? Date(timeIntervalSince1970: 0),
            isFavorite: isFavorite,
            isCloudItem: items.first(where: { $0.isCloudItem })?.isCloudItem ?? false,
            artwork: { self.catalogArtwork },
            items: {
                self.items.enumerated().compactMap { index, item in
                    guard let id = item.localItemID else { return nil }
                    return LibraryItem(
                        track: index + 1,
                        title: item.title ?? "",
                        id: id,
                        albumID: item.albumPersistentID,
                        duration: item.playbackDuration,
                        isCloudItem: item.isCloudItem
                    )
                }
            }
        )
    }
}
