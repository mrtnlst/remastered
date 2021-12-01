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
    func play(id: String, of category: CategoryType) -> Effect<Never, Never>
}

final class DefaultPlaybackService: PlaybackService {
    func play(id: String, of category: CategoryType) -> Effect<Never, Never> {
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
        
        MPMusicPlayerController.systemMusicPlayer.setQueue(with: query)
        MPMusicPlayerController.systemMusicPlayer.prepareToPlay()
        MPMusicPlayerController.systemMusicPlayer.play()
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}

