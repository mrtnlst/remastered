//
//  PlaybackAction.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import Foundation

enum PlaybackAction: Equatable {
    case togglePlayback
    case forward
    case onAppear
    case receivePlaybackProperties(Result<PlaybackProperties, Never>)
    case playbackStateDidChange
    case didBecomeActive
}
