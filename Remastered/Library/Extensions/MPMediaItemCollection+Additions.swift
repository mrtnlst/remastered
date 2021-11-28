//
//  MPMediaItemCollection+Additions.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    
    var albumTitle: String? {
        representativeItem?.albumTitle
    }
    
    var albumArtist: String? {
        representativeItem?.artist
    }
    
    var mediaPersistentID: String? {
        (representativeItem?.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as? NSNumber)?.stringValue
    }
    
    var dateAdded: Date? {
        representativeItem?.dateAdded
    }
    
    var lastPlayed: Date? {
        let defaultDate = Date(timeIntervalSince1970: 0)
        return items
            .sorted { $0.lastPlayedDate ?? defaultDate > $1.lastPlayedDate ?? defaultDate }
            .first?.lastPlayedDate
    }
    
    var isFavorite: Bool {
        return items.contains { $0.rating > 3 }
    }
    
    var artwork: UIImage? {
        let image = representativeItem?.artwork
        return image?.image(at: CGSize(width: 100, height: 100))
    }
}
