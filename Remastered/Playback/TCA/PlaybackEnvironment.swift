//
//  PlaybackEnvironment.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import Foundation
import CombineSchedulers
import ComposableArchitecture

struct PlaybackEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var playbackProperties: () -> Effect<PlaybackProperties, Never>
    var togglePlayback: () -> Effect<Never, Never>
    var toggleShuffle: () -> Effect<Never, Never>
    var toggleRepeat: () -> Effect<Never, Never>
    var forward: () -> Effect<Never, Never>
    var backward: () -> Effect<Never, Never>
}
