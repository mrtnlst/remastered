//
//  LibraryCategoryState.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryCategoryState: Equatable, Identifiable {
    var items: IdentifiedArrayOf<LibraryItemState> = []
    var type: LibraryCategoryType
    var id: UUID = UUID()
}

// MARK: - Simulator
extension LibraryCategoryState {
    static let exampleCategories: IdentifiedArrayOf<LibraryCategoryState> = [
        LibraryCategoryState(
            items: .init(
                uniqueElements: [
                    LibraryItemState(item: LibraryCollection.exampleAlbums.last!),
                    LibraryItemState(item: LibraryCollection.exampleAlbums.first!)
                ]
            ),
            type: .playlists
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .artists
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .albums
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .songs
        ),
        LibraryCategoryState(
            items: exampleItems,
            type: .genres
        ),
    ]
    
    static let exampleItems: IdentifiedArrayOf<LibraryItemState> = [
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
}
