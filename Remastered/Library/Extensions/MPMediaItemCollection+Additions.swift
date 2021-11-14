//
//  MPMediaItemCollection+Additions.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    
    var albumTitle: String? {
        representativeItem?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
    }
    
    var albumArtist: String? {
        representativeItem?.value(forProperty: MPMediaItemPropertyAlbumArtist) as? String
    }
    
    var mediaPersistentID: String? {
        (representativeItem?.value(forProperty: MPMediaItemPropertyAlbumPersistentID) as? NSNumber)?.stringValue
    }
}
