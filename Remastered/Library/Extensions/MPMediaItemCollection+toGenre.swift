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
              let title = representativeItem?.genre,
              let dateAdded = dateAdded
        else {
            return nil
        }
        return LibraryCollection(
            id: id.stringValue,
            title: title,
            subtitle: numberOfItems,
            dateAdded: dateAdded,
            lastPlayed: lastPlayed ?? Date(timeIntervalSince1970: 0),
            isFavorite: isFavorite,
            artwork: { nil },
            items: {
                self.items.enumerated().compactMap { index, item in
                    guard let id = item.mediaPersistentID else { return nil }
                    return LibraryItem(
                        track: index + 1,
                        title: item.title ?? "",
                        id: id,
                        duration: item.playbackDuration
                    )
                }
            }
        )
    }
}
