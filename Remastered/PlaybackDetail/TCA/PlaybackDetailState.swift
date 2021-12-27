//
//  PlaybackDetailState.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import MediaPlayer

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
    
    var isShuffleOn: Bool {
        properties?.shuffleMode != .off
    }
    
    var isRepeatOn: Bool {
        properties?.repeatMode != MPMusicRepeatMode.none
    }
    
    var isRepeatOneOn: Bool {
        properties?.repeatMode == .one
    }
}
