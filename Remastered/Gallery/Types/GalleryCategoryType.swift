//
//  GalleryCategoryType.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import Foundation

enum GalleryCategoryType: String, CaseIterable {
    case discover = "Discover"
    case favorites = "Greatest Hits"
    case recentlyAdded = "Recently Added"
    case recentlyPlayed = "Recently Played"    
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
    
    var uuid: UUID {
        switch self {
        case .discover:
            return UUID(uuidString: "f0e6f568-bcf1-4e02-bd5f-fd2f945f2c0f")!
        case .favorites:
            return UUID(uuidString: "04ebb93c-fe3d-471c-91f0-fd01c073e2ed")!
        case .recentlyAdded:
            return UUID(uuidString: "3d7416dd-6d8d-4dc3-9a10-fc8a6c3f5d28")!
        case .recentlyPlayed:
            return UUID(uuidString: "2a3deecc-a753-405e-bdfe-ad13e5223fdc")!
        }
    }
}
