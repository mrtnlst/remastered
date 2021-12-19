//
//  PlaybackProperties.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import MediaPlayer

struct PlaybackProperties: Equatable {
    let playbackState: MPMusicPlaybackState
    let repeatMode: MPMusicRepeatMode
    let shuffleMode: MPMusicShuffleMode
}
