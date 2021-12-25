//
//  PlaybackReducer.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import ComposableArchitecture
import UIKit

let playbackReducer = Reducer<PlaybackState, PlaybackAction, PlaybackEnvironment> { state, action, environment in
    switch action {
    case .onAppear:
#if targetEnvironment(simulator)
        return Effect(value: .nowPlayingItemDidChange)
#else
        return .merge(
            NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
                .map { _ in .playbackStateDidChange }
                .eraseToEffect(),
            NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
                .map { _ in .playbackStateDidChange }
                .eraseToEffect(),
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in .didBecomeActive }
                .eraseToEffect()
        )
#endif
        
    case .didBecomeActive:
        return Effect(value: .playbackStateDidChange)
        
    case .playbackStateDidChange:
        return environment
            .playbackProperties()
            .receive(on: environment.mainQueue)
            .catchToEffect(PlaybackAction.receivePlaybackProperties)

    case let .receivePlaybackProperties(.success(properties)):
        state.isPlaying = properties.playbackState == .playing
        if let item = properties.nowPlayingItem {
            state.songTitle = item.title
            state.songArtwork = item.artwork()
        }
        return .none
        
    case .togglePlayback:
        return environment
            .togglePlayback()
            .fireAndForget()
        
    case .forward:
        return environment
            .forward()
            .fireAndForget()
    }
}
