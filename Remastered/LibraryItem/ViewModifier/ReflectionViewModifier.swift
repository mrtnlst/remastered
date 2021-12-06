//
//  ReflectionViewModifier.swift
//  Remastered
//
//  Created by martin on 06.12.21.
//

import SwiftUI

private struct ReflectionViewModifier: ViewModifier {
    let offsetY: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(
                content
                    .mask(LinearGradient(
                        gradient: Gradient(
                            stops: [.init(color: .white, location: 0.0), .init(color: .clear, location: 0.2)]
                        ),
                        startPoint: .bottom,
                        endPoint: .top)
                         )
                    .scaleEffect(x: 1.0, y: -1.0, anchor: .bottom)
                    .opacity(colorScheme == .light ? 0.1 : 0.3)
                    .offset(y: offsetY)
            )
    }
}

extension View {
    func reflection(offsetY: CGFloat = 1) -> some View {
        modifier(ReflectionViewModifier(offsetY: offsetY))
    }
}


struct ReflectionViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            HStack {
                if let artwork = LibraryCategoryState.exampleItems.first?.item.artwork() {
                    Image(uiImage: artwork)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .frame(maxHeight: 180)
                        .reflection(offsetY: 10)
                }
            }
            .preferredColorScheme($0)
        }
    }
}
