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
    var nowPlayingItem: () -> Effect<LibraryItem?, Never>
    var playbackProperties: () -> Effect<PlaybackProperties, Never>
    var togglePlayback: () -> Effect<Never, Never>
    var forward: () -> Effect<Never, Never>
}
