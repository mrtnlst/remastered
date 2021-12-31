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
    @State var isSelected: Bool = false
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Spacer()
                HStack {
                    ArtworkView(with: .item(viewStore.libraryItem), cornerRadius: 4, shadowRadius: 2)
                        .padding(.vertical, 8)
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
                .background(isSelected ? Color.gray.opacity(0.05) : .clear)
                .background(
                    isSelected ? .ultraThinMaterial : .thinMaterial,
                    in: RoundedRectangle(cornerRadius: 12)
                )
                .padding(.bottom, viewStore.tabBarHeight + viewStore.tabBarOffset + 16)
                .padding(.horizontal)
                .transition(.move(edge: .bottom))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isSelected = true }
                        .onEnded { _ in
                            isSelected = false
                            viewStore.send(.setIsDetailPresented(true))
                        }
                )
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
                            nowPlayingItem: nil
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
