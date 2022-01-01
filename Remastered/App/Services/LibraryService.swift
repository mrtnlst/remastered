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
    func fetchCollection(for id: String, of type: LibraryCategoryType) -> Effect<LibraryCollection?, Never>
}

final class DefaultLibraryService {}

#if targetEnvironment(simulator)
extension DefaultLibraryService: LibraryService {
    func fetch() -> Effect<[LibraryCollection], Never> {
        Future { $0(.success(LibraryCollection.exampleAlbums)) }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchCollection(for id: String, of type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
        return Just(LibraryCollection.exampleAlbums.first!).eraseToAnyPublisher().eraseToEffect()
    }
}
#else
extension DefaultLibraryService: LibraryService {
    func fetch() -> Effect<[LibraryCollection], Never> {
        Future { promise in
            #if targetEnvironment(simulator)
            promise(.success(LibraryCollection.exampleAlbums))
            #else
            var collections: [LibraryCollection] = []
            
            let albumQuery = MPMediaQuery.albums()
            albumQuery.groupingType = .album
            let albums = albumQuery.collections?.compactMap { $0.toAlbum() } ?? []
            collections.append(contentsOf: albums.uniques())
            
            let playlistQuery = MPMediaQuery.playlists()
            playlistQuery.groupingType = .playlist
            let playlists = playlistQuery.collections?.compactMap { $0.toPlaylist() } ?? []
            collections.append(contentsOf: playlists.uniques())
            
            let genreQuery = MPMediaQuery.genres()
            genreQuery.groupingType = .genre
            let genres = genreQuery.collections?.compactMap { $0.toGenre() } ?? []
            collections.append(contentsOf: genres.uniques())
            
            let artistQuery = MPMediaQuery.artists()
            artistQuery.groupingType = .albumArtist
            let artists = artistQuery.collections?.compactMap { $0.toArtist() } ?? []
            collections.append(contentsOf: artists.uniques())
            
            promise(.success(collections))
            #endif
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchCollection(for id: String, of type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
        switch type {
        case .artist:
            let predicate = MPMediaPropertyPredicate(
                value: id,
                forProperty: MPMediaItemPropertyArtistPersistentID,
                comparisonType: MPMediaPredicateComparison.equalTo
            )
            let filter: Set<MPMediaPropertyPredicate> = [predicate]
            let query = MPMediaQuery(filterPredicates: filter)
            query.groupingType = .artist
            
            let result = query.collections?.first?.toArtist()
            return Just(result).eraseToAnyPublisher().eraseToEffect()
        default:
            let predicate = MPMediaPropertyPredicate(
                value: id,
                forProperty: MPMediaItemPropertyAlbumPersistentID,
                comparisonType: MPMediaPredicateComparison.equalTo
            )
            let filter: Set<MPMediaPropertyPredicate> = [predicate]
            let query = MPMediaQuery(filterPredicates: filter)
            query.groupingType = .album
            
            let result = query.collections?.first?.toAlbum()
            return Just(result).eraseToAnyPublisher().eraseToEffect()
        }
    }
}
#endif
