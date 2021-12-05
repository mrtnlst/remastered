//
//  GalleryCategoryType.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import Foundation

enum GalleryCategoryType: String, CaseIterable {
    case recentlyAdded = "Recently Added"
    case recentlyPlayed = "Recently Played"
    case favorites = "Greatest Hits"
    case discover = "Discover"
}

extension GalleryCategoryType {
    var sortOrder: (LibraryCollection, LibraryCollection) -> Bool {
        switch self {
        case .recentlyAdded:
            return { lhs, rhs in lhs.dateAdded > rhs.dateAdded }
        case .discover:
            return { lhs, rhs in lhs.lastPlayed < rhs.lastPlayed }
        default:
            return { lhs, rhs in lhs.lastPlayed > rhs.lastPlayed }
        }
    }
    
    var filterValue: (LibraryCollection) -> Bool {
        switch self {
        case .favorites:
            return { item in item.isFavorite }
        default:
            return { _ in true }
        }
    }
}
