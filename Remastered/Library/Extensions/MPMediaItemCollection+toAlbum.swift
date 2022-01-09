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
              let libraryId = LibraryId(id.stringValue),
              let title = representativeItem?.albumTitle,
              let subtitle = artist
        else {
            return nil
        }
        return LibraryCollection(
            type: .album,
            libraryId: libraryId,
            title: title,
            subtitle: subtitle,
            isFavorite: isFavorite,
            isCloudItem: items.first(where: { $0.isCloudItem })?.isCloudItem ?? false,
            artwork: { self.artwork },
            items: {
                self.items.compactMap { item in
                    guard let id = item.libraryId else { return nil }
                    return LibraryItem(
                        libraryId: id,
                        album: item.libraryAlbum,
                        artist: item.libraryArtist,
                        track: item.albumTrackNumber,
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
