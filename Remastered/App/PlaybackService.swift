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
    func play(for id: String) -> Effect<Never, Never>
}

final class DefaultPlaybackService: PlaybackService {
    func play(for id: String) -> Effect<Never, Never> {
        MPMusicPlayerController.systemMusicPlayer.shuffleMode = .off
        let predicate = MPMediaPropertyPredicate(value: id,
                                             forProperty: MPMediaItemPropertyAlbumPersistentID,
                                             comparisonType: MPMediaPredicateComparison.equalTo)
        
        let filter: Set<MPMediaPropertyPredicate> = [predicate]
        let query = MPMediaQuery(filterPredicates: filter)
        
        MPMusicPlayerController.systemMusicPlayer.setQueue(with: query)
        MPMusicPlayerController.systemMusicPlayer.prepareToPlay()
        MPMusicPlayerController.systemMusicPlayer.play()
        return Empty().eraseToAnyPublisher().eraseToEffect()
    }
}

