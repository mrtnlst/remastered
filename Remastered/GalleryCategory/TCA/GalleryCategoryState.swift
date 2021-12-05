//
//  GalleryCategoryState.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import Foundation
import IdentifiedCollections

struct GalleryCategoryState: Equatable, Identifiable {
    var items: IdentifiedArrayOf<LibraryItemState>
    var type: GalleryCategoryType
    var id: UUID = UUID()
}

// MARK: - Simulator
extension GalleryCategoryState {
    static let exampleCategories: IdentifiedArrayOf<GalleryCategoryState> = [
        GalleryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.recentlyAdded.filterValue)
                    .sorted(by: GalleryCategoryType.recentlyAdded.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            type: .recentlyAdded
        ),
        GalleryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.recentlyPlayed.filterValue)
                    .sorted(by: GalleryCategoryType.recentlyPlayed.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            type: .recentlyPlayed
        ),
        GalleryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.favorites.filterValue)
                    .sorted(by: GalleryCategoryType.favorites.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            type: .favorites
        ),
        GalleryCategoryState(
            items: .init(
                uniqueElements: LibraryCollection.exampleAlbums
                    .filter(GalleryCategoryType.discover.filterValue)
                    .sorted(by: GalleryCategoryType.discover.sortOrder)
                    .map { LibraryItemState(item: $0) }
            ),
            type: .discover
        )
    ]
}





