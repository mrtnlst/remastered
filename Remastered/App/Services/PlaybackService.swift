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
    func play(id: String, of category: LibraryCategoryType, from position: Int?) -> Effect<Never, Never>
    func nowPlayingItem() -> Effect<LibraryItem?, Never>
    func playbackProperties() -> Effect<PlaybackProperties, Never>
    func togglePlayback() -> Effect<Never, Never>
    func forward() -> Effect<Never, Never>
}

final class DefaultPlaybackService: PlaybackService {
    func play(id: String, of category: LibraryCategoryType, from position: Int?) -> Effect<Never, Never> {
        MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
        var predicate: MPMediaPropertyPredicate
        
        switch category {
        case .albums:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
            predicate = MPMediaPropertyPredicate(value: id,
                                                 forProperty: MPMediaItemPropertyAlbumPersistentID,
                                                 comparisonType: MPMediaPredicateComparison.equalTo)
        case .playlists:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
            predicate = MPMediaPropertyPredicate(value: UInt64(id),
                                                 forProperty: MPMediaPlaylistPropertyPersistentID,
                                                 comparisonType: MPMediaPredicateComparison.equalTo)
        case .artists:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .songs
            predicate = MPMediaPropertyPredicate(value: id,
                                                 forProperty: MPMediaItemPropertyArtistPersistentID,
                                                 comparisonType: MPMediaPredicateComparison.equalTo)
        case .genres:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .songs
            predicate = MPMediaPropertyPredicate(value: id,
                                                 forProperty: MPMediaItemPropertyGenrePersistentID,
                                                 comparisonType: MPMediaPredicateComparison.equalTo)
        case .songs:
            MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
            predicate = MPMediaPropertyPredicate(value: id,
                                                 forProperty: MPMediaItemPropertyPersistentID,
                                                 comparisonType: MPMediaPredicateComparison.equalTo)
        }
        
        let filter: Set<MPMediaPropertyPredicate> = [predicate]
        let query = MPMediaQuery(filterPredicates: filter)
        var items: [MPMediaItem] = query.items ?? []
        
        // TODO: When backwarding, the first songs are not found, perhaps there is a better way?
        // MPMusicPlayerMediaItemQueueDescriptor with start item
        switch category {
        case .albums:
            if let position = position {
                items.removeAll { $0.albumTrackNumber < position }
            }
        default:
            if let position = position {
                items.removeFirst(position - 1)
            }
        }
        
        MPMusicPlayerController.systemMusicPlayer.setQueue(with: MPMediaItemCollection(items: items))
        MPMusicPlayerController.systemMusicPlayer.prepareToPlay()
        MPMusicPlayerController.systemMusicPlayer.play()
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func nowPlayingItem() -> Effect<LibraryItem?, Never> {
        #if targetEnvironment(simulator)
        return Just(LibraryItem.playlistItems.first!).eraseToAnyPublisher().eraseToEffect()
        #else
        if let item = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem,
           let id = item.localItemID {
            let libraryItem = LibraryItem(
                track: item.albumTrackNumber,
                title: item.title ?? "",
                id: id,
                albumID: item.albumPersistentID,
                duration: item.playbackDuration,
                isCloudItem: item.isCloudItem,
                artwork: { item.itemArtwork }
            )
            return Just(libraryItem).eraseToAnyPublisher().eraseToEffect()
        }
        return Just(nil).eraseToAnyPublisher().eraseToEffect()
        #endif
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
    
    func forward() -> Effect<Never, Never> {
        MPMusicPlayerController.systemMusicPlayer.skipToNextItem()
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
    
    func playbackProperties() -> Effect<PlaybackProperties, Never> {
        let properties = PlaybackProperties(
            playbackState: MPMusicPlayerController.systemMusicPlayer.playbackState,
            repeatMode: MPMusicPlayerController.systemMusicPlayer.repeatMode,
            shuffleMode: MPMusicPlayerController.systemMusicPlayer.shuffleMode
        )
        return Just(properties).eraseToAnyPublisher().eraseToEffect()
    }
}

