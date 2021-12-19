//
//  PlaybackState.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import UIKit

struct PlaybackState: Equatable {
    var isPlaying: Bool = false
    var songTitle: String? = nil
    var songArtwork: UIImage? = nil
    var tabBarHeight: CGFloat = 0
    var tabBarOffset: CGFloat = 0
}
