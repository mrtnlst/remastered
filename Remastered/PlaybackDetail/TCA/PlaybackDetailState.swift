//
//  PlaybackDetailState.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import Foundation

struct PlaybackDetailState: Equatable {
    var properties: PlaybackProperties?
}

extension PlaybackDetailState {
    var isPlaying: Bool {
        properties?.playbackState == .playing
    }
    
    var libraryItem: LibraryItem? {
        properties?.nowPlayingItem
    }
}
