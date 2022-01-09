//
//  LibraryCategoryState.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryCategoryState: Equatable, Identifiable {
    var id: UUID = UUID()
    var items: IdentifiedArrayOf<LibraryItemState> = []
    var name: String
    var icon: String?
}

// MARK: - Simulator
extension LibraryCategoryState {
    static let exampleLibraryCategories: IdentifiedArrayOf<LibraryCategoryState> = [
        LibraryCategoryState(
            items: exampleLibraryPlaylists,
            name: LibraryCategoryType.playlist.text,
            icon: LibraryCategoryType.playlist.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryArtists,
            name: LibraryCategoryType.artist.text,
            icon: LibraryCategoryType.artist.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.album.text,
            icon: LibraryCategoryType.album.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.song.text,
            icon: LibraryCategoryType.song.icon
        ),
        LibraryCategoryState(
            items: exampleLibraryAlbums,
            name: LibraryCategoryType.genre.text,
            icon: LibraryCategoryType.genre.icon
        ),
    ]
    
    static let exampleGalleryRows: IdentifiedArrayOf<GalleryRowState> = [
        GalleryRowState(
            id: UUID(),
            category: LibraryCategoryState(
                items: .init(
                    uniqueElements: LibraryCollection.exampleAlbums
                        .map { LibraryItemState(collection: $0) }
                ),
                name: GalleryCategoryType.discover.rawValue
            )
        ),
        GalleryRowState(
            id: UUID(),
            category: LibraryCategoryState(
                items: .init(
                    uniqueElements: LibraryCollection.exampleAlbums
                        .map { LibraryItemState(collection: $0) }
                ),
                name: GalleryCategoryType.favorites.rawValue
            )
        ),
        GalleryRowState(
            id: UUID(),
            category: LibraryCategoryState(
                items: .init(
                    uniqueElements: LibraryCollection.exampleAlbums
                        .map { LibraryItemState(collection: $0) }
                ),
                name: GalleryCategoryType.recentlyAdded.rawValue
            )
        ),
        GalleryRowState(
            id: UUID(),
            category: LibraryCategoryState(
                items: .init(
                    uniqueElements: LibraryCollection.exampleAlbums
                        .map { LibraryItemState(collection: $0) }
                ),
                name: GalleryCategoryType.recentlyAdded.rawValue
            )
        )
    ]
    
    static let exampleLibraryAlbums: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[0]
        ),
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[1]
        ),
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[2]
        ),
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[3]
        ),
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[4]
        ),
        LibraryItemState(
            collection: LibraryCollection.exampleAlbums[5]
        )
    ]
    
    static let exampleLibraryPlaylists: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            collection: LibraryCollection.examplePlaylists[0]
        )
    ]
    
    static let exampleLibraryArtists: IdentifiedArrayOf<LibraryItemState> = [
        LibraryItemState(
            collection: LibraryCollection.exampleArtists[0]
        )
    ]
}
