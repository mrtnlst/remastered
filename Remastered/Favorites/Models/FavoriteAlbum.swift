//
//  FavoriteAlbum.swift
//  Remastered
//
//  Created by martin on 17.11.21.
//

import Foundation

struct FavoriteAlbum: Identifiable, Equatable {
    let id: String
    var position: Int
    var librayAlbum: LibraryAlbum? = nil
}

extension FavoriteAlbum {
    static let exampleAlbums: [LibraryAlbum] = [
        LibraryAlbum(title: "Whenever You Need Somebody", artist: "Rick Astley", id: "AABB-CCDD-EEFF-KKLL", position: 0)
    ]
}
