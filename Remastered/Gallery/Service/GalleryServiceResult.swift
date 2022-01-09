//
//  GalleryServiceResult.swift
//  Remastered
//
//  Created by martin on 08.01.22.
//

import Foundation

enum GalleryServiceResult: Equatable {
    case discover([LibraryCollection])
    case favorites([LibraryCollection])
    case recentlyAdded([LibraryCollection])
    case recentlyPlayed([LibraryCollection])
}

extension GalleryServiceResult {
    var categoryType: GalleryCategoryType {
        switch self {
        case .discover:
            return .discover
        case .favorites:
            return .favorites
        case .recentlyAdded:
            return .recentlyAdded
        case .recentlyPlayed:
            return .recentlyPlayed
        }
    }
    
    var collections: [LibraryCollection] {
        switch self {
        case .discover(let array),
             .favorites(let array),
             .recentlyAdded(let array),
             .recentlyPlayed(let array):
            return array
        }
    }
}
