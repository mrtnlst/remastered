//
//  AppView.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: Store<AppState, AppAction>
    
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                Text("Is authorized: \(String(viewStore.isAuthorized))")
                    .padding()
                
                    .onAppear {
                        viewStore.send(.authorize)
                    }
            }
            .navigationBarTitle("Remastered", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: .previewState,
                reducer: appReducer,
                environment: .init(authorizationService: AuthorizationService())
            )
        )
    }
}
