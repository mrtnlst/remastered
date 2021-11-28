//
//  GalleryAction.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import Foundation

enum GalleryAction: Equatable {
    case fetch
    case receiveGalleryItems(result: Result<[GalleryRowModel], Never>)
    case didSelectItem(id: String)
}
