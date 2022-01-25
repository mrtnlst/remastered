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
    var libraryId: LibraryId? {
        LibraryId(localItemID)
    }
    var libraryArtist: LibraryArtist? {
        let idProperty = MPMediaItemPropertyArtistPersistentID
        guard let id = LibraryId((value(forProperty: idProperty) as? NSNumber)?.stringValue),
              let name = artist
        else {
            return nil
        }
        return LibraryArtist(id: id, name: name)
    }
    var libraryAlbum: LibraryAlbum? {
        let idProperty = MPMediaItemPropertyAlbumPersistentID
        guard let id = LibraryId((value(forProperty: idProperty) as? NSNumber)?.stringValue),
              let title = albumTitle
        else {
            return nil
        }
        return LibraryAlbum(id: id, title: title)
    }
    var itemArtwork: UIImage? {
        return artwork?.image(at: CGSize(width: 300, height: 300))
    }
}
