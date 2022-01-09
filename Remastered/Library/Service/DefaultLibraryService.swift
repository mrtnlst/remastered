//
//  DefaultLibraryService.swift
//  Remastered
//
//  Created by martin on 08.01.22.
//

import Combine
import MediaPlayer
import ComposableArchitecture

final class DefaultLibraryService {}

// MARK: - Device
#if targetEnvironment(simulator)
#else
extension DefaultLibraryService: LibraryService {
    func fetch(type: LibraryServiceResult) -> Effect<LibraryServiceResult, Never> {
        Future { promise in
            switch type {
            case .playlists:
                let query = MPMediaQuery.playlists()
                let collections = query.collections?.compactMap { $0.toPlaylist() }.uniques() ?? []
                promise(.success(.playlists(collections)))
  
            case .albums:
                let query = MPMediaQuery.albums()
                let collections = query.collections?.compactMap { $0.toAlbum() }.uniques() ?? []
                promise(.success(.albums(collections)))
                
            case .artists:
                let query = MPMediaQuery.artists()
                let collections = query.collections?.compactMap { $0.toArtist() }.uniques() ?? []
                promise(.success(.artists(collections)))
                
            case .genres:
                let query = MPMediaQuery.genres()
                let collections = query.collections?.compactMap { $0.toGenre() }.uniques() ?? []
                promise(.success(.genres(collections)))
                
            default:
                promise(.success(.songs([])))
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }

    func fetchCollection(for id: String, of type: LibraryServiceResult) -> Effect<LibraryServiceResult, Never> {
        Future { promise in
            switch type {
            case .artists:
                let predicate = MPMediaPropertyPredicate(
                    value: id,
                    forProperty: MPMediaItemPropertyArtistPersistentID,
                    comparisonType: MPMediaPredicateComparison.equalTo
                )
                let filter: Set<MPMediaPropertyPredicate> = [predicate]
                let query = MPMediaQuery(filterPredicates: filter)
                query.groupingType = .artist
                
                var result: [LibraryCollection] = []
                if let collection = query.collections?.first?.toArtist() {
                    result.append(collection)
                }
                promise(.success(.artists(result)))
            default:
                let predicate = MPMediaPropertyPredicate(
                    value: id,
                    forProperty: MPMediaItemPropertyAlbumPersistentID,
                    comparisonType: MPMediaPredicateComparison.equalTo
                )
                let filter: Set<MPMediaPropertyPredicate> = [predicate]
                let query = MPMediaQuery(filterPredicates: filter)
                query.groupingType = .album
                
                var result: [LibraryCollection] = []
                if let collection = query.collections?.first?.toAlbum() {
                    result.append(collection)
                }
                promise(.success(.albums(result)))
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
#endif

// MARK: - Simulator
#if targetEnvironment(simulator)
extension DefaultLibraryService: LibraryService {
    func fetch(type: LibraryServiceResult) -> Effect<LibraryServiceResult, Never> {
        Future { promise in
            switch type {
            case .playlists:
                promise(.success(.playlists(LibraryCollection.examplePlaylists)))
            case .artists:
                promise(.success(.artists(LibraryCollection.exampleArtists)))
            case .albums:
                promise(.success(.albums(LibraryCollection.exampleAlbums)))
            case .genres:
                promise(.success(.genres(LibraryCollection.exampleGenres)))
            case .songs:
                promise(.success(.songs([])))
            }
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchCollection(for id: String, of type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
        return Just(LibraryCollection.exampleAlbums.first!).eraseToAnyPublisher().eraseToEffect()
    }
    
    func fetchRecentlyPlayed() -> Effect<[LibraryCollection], Never> {
        return Just(LibraryCollection.exampleAlbums).eraseToAnyPublisher().eraseToEffect()
    }
    
    func fetchRecentlyAdded() -> Effect<[LibraryCollection], Never> {
        return Just(LibraryCollection.exampleArtists).eraseToAnyPublisher().eraseToEffect()
    }
}
#endif
