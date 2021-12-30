//
//  PlaybackService.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import ComposableArchitecture
import MediaPlayer
import Combine

protocol PlaybackService {
    func play(id: String, of category: LibraryCategoryType, with startItem: String?) -> Effect<Never, Never>
    func playbackProperties() -> Effect<PlaybackProperties, Never>
    func togglePlayback() -> Effect<Never, Never>
    func toggleShuffle() -> Effect<Never, Never>
    func toggleRepeat() -> Effect<Never, Never>
    func forward() -> Effect<Never, Never>
    func backward() -> Effect<Never, Never>
    func fetchCollection(id: String, type: LibraryCategoryType) -> Effect<LibraryCollection?, Never>
}

final class DefaultPlaybackService {}

#if targetEnvironment(simulator)
extension DefaultPlaybackService: PlaybackService {
    func play(id: String, of category: LibraryCategoryType, with startItem: String?) -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func fetchCollection(id: String, type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
        return Just(LibraryCollection.exampleAlbums.first!).eraseToAnyPublisher().eraseToEffect()
    }
    
    func playbackProperties() -> Effect<PlaybackProperties, Never> {
        let libraryItem = LibraryItem.playlistItems.first
        let properties = PlaybackProperties(
            playbackState: .paused,
            repeatMode: .none,
            shuffleMode: .default,
            nowPlayingItem: libraryItem
        )
        return Just(properties).eraseToAnyPublisher().eraseToEffect()
    }
    
    func togglePlayback() -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func toggleShuffle() -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func toggleRepeat() -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func forward() -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func backward() -> Effect<Never, Never> {
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}
#else
extension DefaultPlaybackService: PlaybackService {
    func play(id: String, of category: LibraryCategoryType, with startItem: String?) -> Effect<Never, Never> {
        return Future<Void, Never> { promise in
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
            var predicate: MPMediaPropertyPredicate
            
            switch category {
            case .album:
                MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
                predicate = MPMediaPropertyPredicate(value: id,
                                                     forProperty: MPMediaItemPropertyAlbumPersistentID,
                                                     comparisonType: MPMediaPredicateComparison.equalTo)
            case .playlist:
                MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
                predicate = MPMediaPropertyPredicate(value: UInt64(id),
                                                     forProperty: MPMediaPlaylistPropertyPersistentID,
                                                     comparisonType: MPMediaPredicateComparison.equalTo)
            case .artist:
                MPMusicPlayerController.systemMusicPlayer.shuffleMode = .songs
                predicate = MPMediaPropertyPredicate(value: id,
                                                     forProperty: MPMediaItemPropertyArtistPersistentID,
                                                     comparisonType: MPMediaPredicateComparison.equalTo)
            case .genre:
                MPMusicPlayerController.systemMusicPlayer.shuffleMode = .songs
                predicate = MPMediaPropertyPredicate(value: id,
                                                     forProperty: MPMediaItemPropertyGenrePersistentID,
                                                     comparisonType: MPMediaPredicateComparison.equalTo)
            case .song:
                MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
                predicate = MPMediaPropertyPredicate(value: id,
                                                     forProperty: MPMediaItemPropertyPersistentID,
                                                     comparisonType: MPMediaPredicateComparison.equalTo)
            }
            
            let filter: Set<MPMediaPropertyPredicate> = [predicate]
            let query = MPMediaQuery(filterPredicates: filter)
            
            let descriptor = MPMusicPlayerMediaItemQueueDescriptor(query: query)
            if let startItem = query.items?.first(where: { $0.localItemID == startItem }) {
                descriptor.startItem = startItem
            }
            
            MPMusicPlayerController.systemMusicPlayer.setQueue(with: descriptor)
            MPMusicPlayerController.systemMusicPlayer.prepareToPlay { error in
                if error == nil {
                    MPMusicPlayerController.systemMusicPlayer.play()
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
        .ignoreOutput()
        .eraseToEffect()
    }
    
    func fetchCollection(id: String, type: LibraryCategoryType) -> Effect<LibraryCollection?, Never> {
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
    
    func playbackProperties() -> Effect<PlaybackProperties, Never> {
        var libraryItem: LibraryItem?
        if let item = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem,
           let id = item.libraryId {
            libraryItem = LibraryItem(
                libraryId: id,
                album: item.libraryAlbum,
                artist: item.libraryArtist,
                track: item.albumTrackNumber,
                title: item.title ?? "",
                duration: item.playbackDuration,
                isCloudItem: item.isCloudItem,
                artwork: { item.itemArtwork }
            )
        }

        let properties = PlaybackProperties(
            playbackState: MPMusicPlayerController.systemMusicPlayer.playbackState,
            repeatMode: MPMusicPlayerController.systemMusicPlayer.repeatMode,
            shuffleMode: MPMusicPlayerController.systemMusicPlayer.shuffleMode,
            nowPlayingItem: libraryItem
        )
        return Just(properties).eraseToAnyPublisher().eraseToEffect()
    }
    
    func togglePlayback() -> Effect<Never, Never> {
        switch MPMusicPlayerController.systemMusicPlayer.playbackState {
        case .stopped, .paused:
            MPMusicPlayerController.systemMusicPlayer.play()
        case .playing:
            MPMusicPlayerController.systemMusicPlayer.pause()
        default:
            break
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func toggleShuffle() -> Effect<Never, Never> {
        switch MPMusicPlayerController.systemMusicPlayer.shuffleMode {
        case .off:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .songs
        default:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func toggleRepeat() -> Effect<Never, Never> {
        switch MPMusicPlayerController.systemMusicPlayer.repeatMode {
        case .none:
            MPMusicPlayerController.systemMusicPlayer.repeatMode = .all
        case .all:
            MPMusicPlayerController.systemMusicPlayer.repeatMode = .one
        case .one, .`default`:
            MPMusicPlayerController.systemMusicPlayer.repeatMode = .none
        @unknown default:
            MPMusicPlayerController.systemMusicPlayer.repeatMode = .none
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func forward() -> Effect<Never, Never> {
        MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func backward() -> Effect<Never, Never> {
        if MPMusicPlayerController.systemMusicPlayer.currentPlaybackTime < 5 {
            MPMusicPlayerController.systemMusicPlayer.skipToPreviousItem()
        } else {
            MPMusicPlayerController.systemMusicPlayer.skipToBeginning()
        }
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}
#endif

