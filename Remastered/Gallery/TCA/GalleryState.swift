//
//  GalleryState.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation
import IdentifiedCollections
import ComposableArchitecture

struct GalleryState: Equatable {
    var rows: IdentifiedArrayOf<GalleryRowState> = []
}

extension GalleryState {
    static var initialRows: IdentifiedArrayOf<GalleryRowState> {
        .init(
            uniqueElements: GalleryCategoryType.allCases.map {
                GalleryRowState(
                    id: $0.uuid,
                    category: LibraryCategoryState(
                        id: $0.uuid,
                        items: [],
                        name: $0.rawValue
                    )
                )
            }
        )
    }
}
