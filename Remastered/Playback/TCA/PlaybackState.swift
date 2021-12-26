//
//  PlaybackState.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import UIKit

struct PlaybackState: Equatable {
    var properties: PlaybackProperties?
    var playbackDetail: PlaybackDetailState?
    var tabBarHeight: CGFloat = 0
    var tabBarOffset: CGFloat = 0
    var isDetailPresented: Bool = false
}

extension PlaybackState {
    var isPlaying: Bool {
        properties?.playbackState == .playing
    }
    
    var libraryItem: LibraryItem? {
        properties?.nowPlayingItem
    }
}
