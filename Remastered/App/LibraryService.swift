//
//  LibraryService.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Combine
import ComposableArchitecture
import MediaPlayer

protocol LibraryService {
    func fetch() -> Effect<[LibraryCollection], Never>
}

final class DefaultLibraryService: LibraryService {

    func fetch() -> Effect<[LibraryCollection], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            promise(.success(LibraryCollection.exampleAlbums))
            #else
            let query = MPMediaQuery()
            var collections: [LibraryCollection] = []
            
            query.groupingType = .album
            let albums = query.collections?.compactMap { $0.toAlbum() } ?? []
            collections.append(contentsOf: albums)
            
            query.groupingType = .playlist
            let playlists = query.collections?.compactMap { $0.toPlaylist() } ?? []
            collections.append(contentsOf: playlists)
            
            query.groupingType = .genre
            let genres = query.collections?.compactMap { $0.toGenre() } ?? []
            collections.append(contentsOf: genres)
            
            query.groupingType = .title
            
            query.groupingType = .albumArtist
            let artists = query.collections?.compactMap { $0.toArtist() } ?? []
            collections.append(contentsOf: artists)
            
            promise(.success(collections))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
