//
//  PlaybackDetailReducer.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import ComposableArchitecture

let playbackDetailReducer = Reducer<PlaybackDetailState, PlaybackDetailAction, PlaybackDetailEnvironment> { state, action, environment in
    switch action {
    case let .receivePlaybackProperties(.success(properties)):
        state.properties = properties
        return .none
        
    case .togglePlayback:
        return environment
            .togglePlayback()
            .fireAndForget()
        
    case .forward:
        return environment
            .forward()
            .fireAndForget()
        
    case .backward:
        return environment
            .backward()
            .fireAndForget()
    }
}
