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

// MARK: - Custom Initializer
extension GalleryCategoryType {
    init?(from uuid: UUID) {
        switch uuid {
        case GalleryCategoryType.discover.uuid:
            self = .discover
        case GalleryCategoryType.favorites.uuid:
            self = .favorites
        case GalleryCategoryType.recentlyAdded.uuid:
            self = .recentlyAdded
        case GalleryCategoryType.recentlyPlayed.uuid:
            self = .recentlyPlayed
        default: return nil
        }
    }
}

// MARK: - Mapping
extension GalleryCategoryType {
    var serviceResult: GalleryServiceResult {
        switch self {
        case .discover:
            return .discover([])
        case .favorites:
            return .favorites([])
        case .recentlyAdded:
            return .recentlyAdded([])
        case .recentlyPlayed:
            return .recentlyPlayed([])
        }
    }
}

// MARK: - Properties
extension GalleryCategoryType {
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
