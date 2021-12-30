//
//  MPMediaItemCollection+toGenre.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    func toGenre() -> LibraryCollection? {
        let idProperty = MPMediaItemPropertyGenrePersistentID
        guard let id = representativeItem?.value(forProperty: idProperty) as? NSNumber,
              let libraryId = LibraryId(id.stringValue),
              let title = representativeItem?.genre,
              let dateAdded = dateAdded
        else {
            return nil
        }
        return LibraryCollection(
            type: .genre,
            libraryId: libraryId,
            title: title,
            subtitle: numberOfItems,
            dateAdded: dateAdded,
            lastPlayed: lastPlayed ?? Date(timeIntervalSince1970: 0),
            isFavorite: isFavorite,
            isCloudItem: items.first(where: { $0.isCloudItem })?.isCloudItem ?? false,
            artwork: { nil },
            items: {
                self.items.enumerated().compactMap { index, item in
                    guard let id = item.libraryId else { return nil }
                    return LibraryItem(
                        libraryId: id,
                        album: item.libraryAlbum,
                        artist: item.libraryArtist,
                        track: index + 1,
                        title: item.title ?? "",
                        duration: item.playbackDuration,
                        isCloudItem: item.isCloudItem,
                        artwork: { item.itemArtwork }
                    )
                }
            }
        )
    }
}
