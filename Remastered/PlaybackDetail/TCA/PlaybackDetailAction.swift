//
//  PlaybackDetailAction.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import Foundation

enum PlaybackDetailAction: Equatable {
    case togglePlayback
    case toggleShuffle
    case toggleRepeat
    case forward
    case backward
    case receivePlaybackProperties(Result<PlaybackProperties, Never>)
}
