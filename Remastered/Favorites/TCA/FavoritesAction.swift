//
//  FavoritesAction.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import Foundation

enum FavoritesAction: Equatable {
    case fetchFavorites
    case receiveFavorites(Result<[LibraryAlbum], Never>)
}
