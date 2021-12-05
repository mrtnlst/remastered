//
//  GalleryState.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation
import IdentifiedCollections

struct GalleryState: Equatable {
    var categories: IdentifiedArrayOf<GalleryCategoryState> = []
}
