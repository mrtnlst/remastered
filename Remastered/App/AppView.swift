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
        WithViewStore(store) { viewStore in
            NavigationView {
                FavoritesView(store: store.scope(state: { $0.favorites }, action: AppAction.favorites))
                .navigationBarTitle("Remastered", displayMode: .large)
                .navigationBarItems(
                    trailing:
                        Button(action: { viewStore.send(.setLibrary(isPresenting: true)) }) {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                        }
                )
            }
            .sheet(isPresented: viewStore.binding(get: \.isLibraryPresenting, send: .setLibrary(isPresenting: false))) {
                IfLetStore(
                    store.scope(
                        state: { $0.library },
                        action: AppAction.library),
                    then: LibraryView.init(store:),
                    else: {
                        Text("Library access not permitted yet.")
                            .onAppear { viewStore.send(.onAppear) }
                    }
                )
            }
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
                environment: .init(
                    libraryService: DefaultLibraryService(),
                    authorizationService: DefaultAuthorizationService(),
                    favoritesService: FavoritesService()
                )
            )
        )
    }
}
