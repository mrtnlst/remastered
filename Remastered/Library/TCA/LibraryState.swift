//
//  LibraryState.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import Foundation
import IdentifiedCollections

struct LibraryState: Equatable {
    var categories: IdentifiedArrayOf<LibraryCategoryState> = []
}
