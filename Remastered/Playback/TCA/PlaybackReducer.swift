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
        return .merge(
            Effect(value: .didBecomeActive),
            NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
                .map { _ in .playbackStateDidChange }
                .eraseToEffect(),
            NotificationCenter.default.publisher(for: .MPMusicPlayerControllerNowPlayingItemDidChange)
                .map { _ in .nowPlayingItemDidChange }
                .eraseToEffect(),
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
                .map { _ in .didBecomeActive }
                .eraseToEffect()
        )
        
    case .didBecomeActive:
        return .merge(
            Effect(value: .nowPlayingItemDidChange),
            Effect(value: .playbackStateDidChange)
        )
        
    case let .receiveNowPlayingItem(.success(item)):
        if let item = item {
            state.songTitle = item.title
            state.songArtwork = item.artwork()
        }
        return .none
        
    case .playbackStateDidChange:
        return environment
            .playbackProperties()
            .receive(on: environment.mainQueue)
            .catchToEffect(PlaybackAction.receivePlaybackProperties)
        
    case .nowPlayingItemDidChange:
        return environment
            .nowPlayingItem()
            .receive(on: environment.mainQueue)
            .catchToEffect(PlaybackAction.receiveNowPlayingItem)
        
    case let .receivePlaybackProperties(.success(properties)):
        state.isPlaying = properties.playbackState == .playing
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
