//
//  MPMediaItemCollection+toPlaylist.swift
//  Remastered
//
//  Created by martin on 01.12.21.
//

import Foundation
import MediaPlayer

extension MPMediaItemCollection {    
    func toPlaylist() -> LibraryCollection? {
        let idProperty = MPMediaPlaylistPropertyPersistentID
        guard let playlistSelf = self as? MPMediaPlaylist,
              let id = playlistSelf.value(forProperty: idProperty) as? NSNumber,
              let title = playlistSelf.name,
              let dateAdded = value(forProperty: "dateModified") as? Date
        else {
            return nil
        }
        return LibraryCollection(
            type: .playlists,
            id: id.stringValue,
            title: title,
            subtitle: numberOfItems,
            dateAdded: dateAdded,
            lastPlayed: lastPlayed ?? Date(timeIntervalSince1970: 0),
            isFavorite: isFavorite,
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
                        artwork: { item.itemArtwork }
                    )
                }
            }
        )
    }
}
