//
//  PlaybackReducer.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import ComposableArchitecture
import UIKit

let playbackReducer = Reducer<PlaybackState, PlaybackAction, PlaybackEnvironment>.combine(
    playbackDetailReducer
        .optional()
        .pullback(
            state: \.playbackDetail,
            action: /PlaybackAction.playbackDetail,
            environment: { env in
                PlaybackDetailEnvironment(
                    mainQueue: env.mainQueue,
                    playbackProperties: env.playbackProperties,
                    togglePlayback: env.togglePlayback,
                    toggleShuffle: env.toggleShuffle,
                    toggleRepeat: env.toggleRepeat,
                    forward: env.forward,
                    backward: env.backward
                )
            }
        ),
    Reducer { state, action, environment in
        switch action {
        case .onAppear:
#if targetEnvironment(simulator)
            return Effect(value: .playbackStateDidChange)
#else
            return .merge(
                Effect(value: .playbackStateDidChange),
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
            state.properties = properties
            
            if state.playbackDetail != nil {
                return Effect(value: .playbackDetail(.receivePlaybackProperties(.success(properties))))
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
            
        case .setIsDetailPresented(true):
            state.playbackDetail = PlaybackDetailState(properties: state.properties)
            state.isDetailPresented = true
            return .none
            
        case .setIsDetailPresented(false):
            state.playbackDetail = nil
            state.isDetailPresented = false
            return .none

        case .playbackDetail(_):
            return .none
            
        case .openItemView(_, _):
            return .none
        }
    }
)
