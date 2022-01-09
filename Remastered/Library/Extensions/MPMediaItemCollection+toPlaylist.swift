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
              let libraryId = LibraryId(id.stringValue),
              let title = playlistSelf.name
        else {
            return nil
        }
        return LibraryCollection(
            type: .playlist,
            libraryId: libraryId,
            title: title,
            subtitle: numberOfItems,
            isFavorite: isFavorite,
            isCloudItem: items.first(where: { $0.isCloudItem })?.isCloudItem ?? false,
            artwork: { self.catalogArtwork },
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
