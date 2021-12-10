//
//  ArtworkView+AnyShape.swift
//  Remastered
//
//  Created by martin on 10.12.21.
//

import SwiftUI

extension ArtworkView {
    
    public struct AnyShape: Shape {
        public var make: (CGRect, inout Path) -> ()

        public init(_ make: @escaping (CGRect, inout Path) -> ()) {
            self.make = make
        }
        public init<S: Shape>(_ shape: S) {
            self.make = { rect, path in
                path = shape.path(in: rect)
            }
        }
        public func path(in rect: CGRect) -> Path {
            return Path { [make] in make(rect, &$0) }
        }
    }
    
    func artworkShape() -> AnyShape {
        switch collection.type {
        case .artists:
            return AnyShape(Circle())
        default:
            return AnyShape(Rectangle())
        }
    }
}
