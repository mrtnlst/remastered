//
//  Sequence+uniques.swift
//  Remastered
//
//  Created by martin on 30.12.21.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func uniques() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
