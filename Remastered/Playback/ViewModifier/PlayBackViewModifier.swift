//
//  PlayBackViewModifier.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import SwiftUI
import ComposableArchitecture

extension View {
    func playBackView(store: Store<AppState, AppAction>) -> some View {
        modifier(PlayBackViewModifier(store: store))
    }
}

struct PlayBackViewModifier: ViewModifier {
    let store: Store<AppState, AppAction>
    
    func body(content: Content) -> some View {
        content
            .overlay {
                IfLetStore(
                    store.scope(
                        state: { $0.playback },
                        action: AppAction.playback
                    )
                ) {
                    PlaybackView(store: $0)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
    }
}
