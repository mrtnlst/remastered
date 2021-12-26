//
//  PlaybackView.swift
//  Remastered
//
//  Created by martin on 19.12.21.
//

import SwiftUI
import ComposableArchitecture

struct PlaybackView: View {
    let store: Store<PlaybackState, PlaybackAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                HStack {
                    // TODO: use artwork view
                    if let artwork = viewStore.libraryItem?.artwork() {
                        Image(uiImage: artwork)
                            .resizable()
                            .cornerRadius(4)
                            .aspectRatio(contentMode: .fit)
                            .padding(.vertical, 8)
                            
                    } else {
                        Image(systemName: "square.fill")
                    }
                    Text(viewStore.libraryItem?.title ?? "None")
                        .foregroundColor(.secondary)
                        .font(Font.caption)
                        .lineLimit(2)
                    Spacer()
                    Button {
                        viewStore.send(.togglePlayback)
                    } label: {
                        Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                    }
                    Button {
                        viewStore.send(.forward)
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                }
                .padding(.horizontal)
                .frame(height: viewStore.tabBarHeight)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, viewStore.tabBarHeight + viewStore.tabBarOffset + 16)
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
            }
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isDetailPresented,
                    send: PlaybackAction.setIsDetailPresented
                )
            ) {
                IfLetStore(
                    store.scope(
                        state: \.playbackDetail,
                        action: PlaybackAction.playbackDetail
                    )
                ) { detailStore in
                    PlaybackDetailView(store: detailStore)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onTapGesture {
                viewStore.send(.setIsDetailPresented(true))
            }
        }
    }
}

struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            Text("Example")
                .tabItem {
                    Label("Test", systemImage: "square.fill")
                }
        }
        .playBackView(
            store: Store (
                initialState: AppState(
                    playback: PlaybackState(
                        properties: PlaybackProperties(
                            playbackState: .playing,
                            repeatMode: .none,
                            shuffleMode: .default,
                            nowPlayingItem: LibraryItem.playlistItems.first!
                        ),
                        tabBarHeight: 49,
                        tabBarOffset: 34
                    )
                ),
                reducer: appReducer,
                environment: .init(
                    libraryService: DefaultLibraryService(),
                    authorizationService: DefaultAuthorizationService(),
                    playbackService: DefaultPlaybackService()
                )
            )
        )
    }
}
