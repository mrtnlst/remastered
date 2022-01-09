//
//  DefaultGalleryService.swift
//  Remastered
//
//  Created by martin on 08.01.22.
//

import Combine
import MediaPlayer
import ComposableArchitecture

final class DefaultGalleryService {}

// MARK: - Device
#if targetEnvironment(simulator)
#else
extension DefaultGalleryService: GalleryService {
    func fetch(type: GalleryServiceResult) -> Effect<GalleryServiceResult, Never> {
        switch type {
        case .recentlyAdded:
            return fetchRecentlyAdded()
        case .recentlyPlayed:
            return fetchRecentlyPlayed()
        case .discover:
            return fetchDiscover()
        case .favorites:
            return Just(.favorites([])).eraseToAnyPublisher().eraseToEffect()
        }
    }
    
    func fetchDiscover() -> Effect<GalleryServiceResult, Never> {
        Future { promise in
            let songs = MPMediaQuery.songs().items ?? []
            let emptyDate = Date(timeIntervalSince1970: 0)
            let sortedResults = songs.sorted { $0.lastPlayedDate ?? emptyDate < $1.lastPlayedDate ?? emptyDate }
            let filteredResults = sortedResults
                .map { $0.albumPersistentID }
                .uniques()
                .prefix(50)
                .shuffled()
            
            let collections: [LibraryCollection] = filteredResults.compactMap { itemId in
                let predicate = MPMediaPropertyPredicate(
                    value: itemId,
                    forProperty: MPMediaItemPropertyAlbumPersistentID,
                    comparisonType: MPMediaPredicateComparison.equalTo
                )
                let filter: Set<MPMediaPropertyPredicate> = [predicate]
                let query = MPMediaQuery(filterPredicates: filter)
                query.groupingType = .album
                return query.collections?.first?.toAlbum()
            }
            promise(.success(.discover(collections)))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchRecentlyPlayed() -> Effect<GalleryServiceResult, Never> {
        Future { promise in
            let songs = MPMediaQuery.songs().items ?? []
            let emptyDate = Date(timeIntervalSince1970: 0)
            let sortedResults = songs.sorted { $0.lastPlayedDate ?? emptyDate > $1.lastPlayedDate ?? emptyDate }
            let filteredResults = sortedResults
                .map { $0.albumPersistentID }
                .uniques()
                .prefix(50)
            
            let collections: [LibraryCollection] = filteredResults.compactMap { itemId in
                let predicate = MPMediaPropertyPredicate(
                    value: itemId,
                    forProperty: MPMediaItemPropertyAlbumPersistentID,
                    comparisonType: MPMediaPredicateComparison.equalTo
                )
                let filter: Set<MPMediaPropertyPredicate> = [predicate]
                let query = MPMediaQuery(filterPredicates: filter)
                query.groupingType = .album
                return query.collections?.first?.toAlbum()
            }
            promise(.success(.recentlyPlayed(collections)))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
    
    func fetchRecentlyAdded() -> Effect<GalleryServiceResult, Never> {
        Future { promise in
            var collections: [MPMediaItemCollection] = []
            let albums = MPMediaQuery.albums().collections?
                .sorted(by: { $0.dateAdded > $1.dateAdded })
                .prefix(30) ?? []
            collections.append(contentsOf:albums)

            let playlists = MPMediaQuery.playlists().collections?
                .sorted(by: { $0.dateAdded > $1.dateAdded })
                .prefix(30) ?? []
            collections.append(contentsOf: playlists.uniques())

            let libraryCollections = collections
                .sorted(by: { $0.dateAdded > $1.dateAdded })
                .compactMap { collection -> LibraryCollection? in
                    if collection as? MPMediaPlaylist != nil {
                        return collection.toPlaylist()
                    }
                    return collection.toAlbum()
                }
                .uniques()
            promise(.success(.recentlyAdded(libraryCollections)))
        }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
#endif

// MARK: - Simulator
#if targetEnvironment(simulator)
extension DefaultGalleryService: GalleryService {
    func fetch(type: GalleryServiceResult) -> Effect<GalleryServiceResult, Never> {
        switch type {
        case .recentlyAdded:
            return Just(.recentlyAdded(LibraryCollection.exampleArtists)).eraseToAnyPublisher().eraseToEffect()
        case .recentlyPlayed:
            return Just(.recentlyPlayed(LibraryCollection.exampleAlbums)).eraseToAnyPublisher().eraseToEffect()
        case .discover:
            return Just(.discover(LibraryCollection.examplePlaylists)).eraseToAnyPublisher().eraseToEffect()
        case .favorites:
            return Just(.favorites([])).eraseToAnyPublisher().eraseToEffect()
        }
    }
}
#endif
