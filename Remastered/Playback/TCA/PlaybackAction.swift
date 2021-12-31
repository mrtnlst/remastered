//
//  PlaybackAction.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import Foundation

enum PlaybackAction: Equatable {
    case onAppear
    case didBecomeActive
    case playbackStateDidChange
    case receivePlaybackProperties(Result<PlaybackProperties, Never>)
    case playbackDetail(PlaybackDetailAction)
    case setIsDetailPresented(Bool)
    case togglePlayback
    case forward
    case openItemView(persistentId: String?, type: LibraryCategoryType)
}
