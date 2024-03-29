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
            TabView(selection: viewStore.binding(get: \.selectedTab, send: AppAction.didSelectTab)) {
                galleryView(with: viewStore)
                    .background(
                        TabBarProxy(
                            height: viewStore.binding(\.$tabBarHeight),
                            offset: viewStore.binding(\.$tabBarOffset)
                        )
                    )
                    .tabItem {
                        Label("Gallery", systemImage: "rectangle.3.group.fill")
                    }
                    .tag(0)
                libraryView(with: viewStore)
                    .tabItem {
                        Label("Library", systemImage: "rectangle.stack.fill")
                    }
                    .tag(1)
                searchView(with: viewStore)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(2)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear { viewStore.send(.onAppear) }
            .playBackView(store: store)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension AppView {
    @ViewBuilder func libraryView(with viewStore: ViewStore<AppState, AppAction>) -> some View {
        IfLetStore(
            store.scope(
                state: { $0.library },
                action: AppAction.library),
            then: LibraryView.init(store:),
            else: {
                if let isAuthorized = viewStore.isAuthorized, !isAuthorized {
                    Text("Library access not permitted yet.")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.primary)
                }
            }
        )
    }
    
    @ViewBuilder func galleryView(with viewStore: ViewStore<AppState, AppAction>) -> some View {
        IfLetStore(
            store.scope(
                state: { $0.gallery },
                action: AppAction.gallery),
            then: GalleryView.init(store:),
            else: {
                if let isAuthorized = viewStore.isAuthorized, !isAuthorized {
                    Text("Library access not permitted yet.")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.primary)
                }
            }
        )
    }
    @ViewBuilder func searchView(with viewStore: ViewStore<AppState, AppAction>) -> some View {
        IfLetStore(
            store.scope(
                state: { $0.search },
                action: AppAction.search),
            then: SearchView.init(store:),
            else: {
                if let isAuthorized = viewStore.isAuthorized, !isAuthorized {
                    Text("Library access not permitted yet.")
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.primary)
                }
            }
        )
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
                    galleryService: DefaultGalleryService(),
                    authorizationService: DefaultAuthorizationService(),
                    playbackService: DefaultPlaybackService()
                )
            )
        )
    }
}
