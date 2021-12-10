//
//  MPMediaItem+Additions.swift
//  Remastered
//
//  Created by martin on 29.11.21.
//

import MediaPlayer

extension MPMediaItem {
    
    var localItemID: String? {
        (value(forProperty: MPMediaItemPropertyPersistentID) as? NSNumber)?.stringValue
    }
    var albumPersistentID: String? {
        let idProperty = MPMediaItemPropertyAlbumPersistentID
        return (value(forProperty: idProperty) as? NSNumber)?.stringValue
    }
    var itemArtwork: UIImage? {
        return artwork?.image(at: CGSize(width: 100, height: 100))
    }
}
