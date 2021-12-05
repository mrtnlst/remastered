//
//  GalleryCategoryAction.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import Foundation

enum GalleryCategoryAction: Equatable {
    case libraryItem(id: UUID, action: LibraryItemAction)
}
