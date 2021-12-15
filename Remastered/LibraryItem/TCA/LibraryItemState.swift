//
//  LibraryItemState.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryItemState: Equatable, Identifiable {
    var item: LibraryCollection
    var id: UUID = UUID()
    @BindableState var isActive: Bool = false
}

