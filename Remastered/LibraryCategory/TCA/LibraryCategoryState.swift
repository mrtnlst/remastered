//
//  LibraryCategoryState.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct LibraryCategoryState: Equatable, Identifiable {
    var id: UUID = UUID()
    var items: IdentifiedArrayOf<LibraryItemState> = []
    var name: String
    var icon: String?
    @BindableState var isActive: Bool = false
}

// MARK: - Simulator
extension LibraryCategoryState {
    static let exampleLibraryCategories: IdentifiedArrayOf<LibraryCategoryState> = [
        LibraryCategoryState(
            items: exampleLibraryPlaylists,
            name: LibraryCategoryType.playlists.rawValue,
            icon: LibraryCategoryType.playlists.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryArtists,
            name: LibraryCategoryType.artists.rawValue,
            icon: LibraryCategoryType.artists.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.albums.rawValue,
            icon: LibraryCategoryType.albums.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.songs.rawValue,
            icon: LibraryCategoryType.songs.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.genres.rawValue,
            icon: LibraryCategoryType.genres.icon
        ),
    ]
    
    static let exampleGalleryCategories: IdentifiedArrayOf<LibraryCategoryState> = [
        LibraryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.discover.filterValue)
                    .sorted(by: GalleryCategoryType.discover.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            name: GalleryCategoryType.discover.rawValue
        ),
        LibraryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.favorites.filterValue)
                    .sorted(by: GalleryCategoryType.favorites.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            name: GalleryCategoryType.favorites.rawValue
        ),
        LibraryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.recentlyAdded.filterValue)
                    .sorted(by: GalleryCategoryType.recentlyAdded.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            name: GalleryCategoryType.recentlyAdded.rawValue
        ),
        LibraryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.recentlyAdded.filterValue)
                    .sorted(by: GalleryCategoryType.recentlyAdded.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            name: GalleryCategoryType.recentlyAdded.rawValue
        )
    ]
    
    static let exampleLibraryAlbums: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[0]
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[1]
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[2]
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[3]
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[4]
        ),
        LibraryItemState(
            item: LibraryCollection.exampleAlbums[5]
        )
    ]
    
    static let exampleLibraryPlaylists: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            item: LibraryCollection.examplePlaylists[0]
        )
    ]
    
    static let exampleLibraryArtists: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            item: LibraryCollection.exampleArtists[0]
        )
    ]
}
