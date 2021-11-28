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
    var type: LibraryRowModel.RowType
    var id: UUID = UUID()
}
