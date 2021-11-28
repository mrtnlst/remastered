//
//  LibraryItemState.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct LibraryItemState: Equatable, Identifiable {
    var item: LibraryCollection
    var id: UUID = UUID()
}

