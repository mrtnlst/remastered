//
//  FavoritesService.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import Combine
import ComposableArchitecture

protocol FavoritesService {
    func fetch() -> Effect<[LibraryAlbum], Never>
}

final class DefaultFavoritesService: FavoritesService {
    
    func fetch() -> Effect<[LibraryAlbum], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            let favorites = FavoriteAlbum.exampleAlbums.compactMap { favorite -> LibraryAlbum? in
                var album = LibraryAlbum.exampleAlbums.first { $0.id == favorite.id }
                album?.position = favorite.position
                return album
            }
            promise(.success(favorites))
            #else
            promise(.success([]))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
