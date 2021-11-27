//
//  GalleryRowModel.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation

struct GalleryRowModel: Equatable, Identifiable {
    enum RowType: String, CaseIterable {
        case recentlyAdded = "Recently Added"
        case recentlyPlayed = "Recently Played"
        case favorites = "Greatest Hits"
        case discover = "Discover"
    }
    
    var id: UUID = UUID()
    var items: [LibraryAlbum]
    var type: RowType
}

extension GalleryRowModel.RowType {
    var sortOrder: (LibraryAlbum, LibraryAlbum) -> Bool {
        switch self {
        case .recentlyAdded:
            return { lhs, rhs in lhs.dateAdded > rhs.dateAdded }
        case .discover:
            return { lhs, rhs in lhs.lastPlayed < rhs.lastPlayed }
        default:
            return { lhs, rhs in lhs.lastPlayed > rhs.lastPlayed }
        }
    }
    
    var filterValue: (LibraryAlbum) -> Bool {
        switch self {
        case .favorites:
            return { item in item.isFavorite }
        default:
            return { _ in true }
        }
    }
}

extension GalleryRowModel {
    static let exampleRowModels: [GalleryRowModel] = [
        GalleryRowModel(
            items: LibraryAlbum.exampleAlbums
                .filter(GalleryRowModel.RowType.recentlyAdded.filterValue)
                .sorted(by: GalleryRowModel.RowType.recentlyAdded.sortOrder),
            type: .recentlyAdded
        ),
        GalleryRowModel(
            items: LibraryAlbum.exampleAlbums
                .filter(GalleryRowModel.RowType.recentlyPlayed.filterValue)
                .sorted(by: GalleryRowModel.RowType.recentlyPlayed.sortOrder),
            type: .recentlyPlayed
        ),
        GalleryRowModel(
            items: LibraryAlbum.exampleAlbums
                .filter(GalleryRowModel.RowType.favorites.filterValue)
                .sorted(by: GalleryRowModel.RowType.favorites.sortOrder),
            type: .favorites
        ),
        GalleryRowModel(
            items: LibraryAlbum.exampleAlbums
                .filter(GalleryRowModel.RowType.discover.filterValue)
                .sorted(by: GalleryRowModel.RowType.discover.sortOrder),
            type: .discover
        ),
    ]
}
