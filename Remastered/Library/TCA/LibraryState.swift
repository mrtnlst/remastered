//
//  LibraryState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct LibraryState: Equatable {
    var categories: IdentifiedArrayOf<LibraryCategoryState> = []
    var selectedCategory: Identified<LibraryCategoryState.ID, LibraryCategoryState>?
    var selectedItem: Identified<LibraryItemState.ID, LibraryItemState>?
    let emptyNavigationLinkId: UUID = UUID(uuidString: "5E6A0452-25ED-4F2C-8E70-3BB02CC4CEBC")!
}

extension LibraryState {
    static var initialCategories: IdentifiedArrayOf<LibraryCategoryState> {
        .init(
            uniqueElements: LibraryCategoryType.allCases.map {
                LibraryCategoryState(
                    id: $0.uuid,
                    items: [],
                    name: $0.text,
                    icon: $0.icon
                )
            }
        )
    }
}
