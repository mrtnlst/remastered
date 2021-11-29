//
//  MPMediaItem+Additions.swift
//  Remastered
//
//  Created by martin on 29.11.21.
//

import MediaPlayer

extension MPMediaItem {
    
    var mediaPersistentID: String? {
        (value(forProperty: MPMediaItemPropertyPersistentID) as? NSNumber)?.stringValue
    }
}
