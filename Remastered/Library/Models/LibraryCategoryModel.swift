//
//  LibraryCategoryModel.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryCategoryModel: Identifiable, Equatable {
    var type: CategoryType
    var items: [LibraryCollection] = []
    var id: UUID = UUID()
}
