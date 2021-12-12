//
//  CategoryDisplayStyle.swift
//  Remastered
//
//  Created by martin on 12.12.21.
//

import Foundation

enum CategoryDisplayStyle: String, Codable {
    case list = "List"
    case grid = "Grid"
}

extension CategoryDisplayStyle {
    var icon: String {
        switch self {
        case .list:
            return "list.bullet"
        case .grid:
            return "square.grid.2x2.fill"
        }
    }
    
    var text: String {
        return rawValue
    }
}
