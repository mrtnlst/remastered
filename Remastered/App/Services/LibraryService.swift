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
            var collections: [LibraryCollection] = []
            
            let albumQuery = MPMediaQuery.albums()
            albumQuery.groupingType = .album
            let albums = albumQuery.collections?.uniques().compactMap { $0.toAlbum() } ?? []
            collections.append(contentsOf: albums)
            
            let playlistQuery = MPMediaQuery.playlists()
            playlistQuery.groupingType = .playlist
            let playlists = playlistQuery.collections?.uniques().compactMap { $0.toPlaylist() } ?? []
            collections.append(contentsOf: playlists)
            
            let genreQuery = MPMediaQuery.genres()
            genreQuery.groupingType = .genre
            let genres = genreQuery.collections?.uniques().compactMap { $0.toGenre() } ?? []
            collections.append(contentsOf: genres)
            
            let artistQuery = MPMediaQuery.artists()
            artistQuery.groupingType = .albumArtist
            let artists = artistQuery.collections?.uniques().compactMap { $0.toArtist() } ?? []
            collections.append(contentsOf: artists)
            
            promise(.success(collections))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
