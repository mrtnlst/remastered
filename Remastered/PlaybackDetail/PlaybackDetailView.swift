//
//  PlaybackDetailView.swift
//  Remastered
//
//  Created by martin on 26.12.21.
//

import SwiftUI
import ComposableArchitecture

struct PlaybackDetailView: View {
    let store: Store<PlaybackDetailState, PlaybackDetailAction>
    @State var volume: Double = 0
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack {
                        Text(viewStore.libraryItem?.title ?? "None")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .multilineTextAlignment(.center)
                        if let artist = viewStore.libraryItem?.artist {
                            Text("by \(artist.name)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        ArtworkView(with: .item(viewStore.libraryItem), cornerRadius: 16, shadowRadius: 3)
                            .reflection(offsetY: 10)
                            .padding(.bottom, 40)
                            .padding(.horizontal, 16)
                        HStack {
                            Spacer()
                            Button { viewStore.send(.backward) } label: {
                                Image(systemName: "backward.fill")
                                    .font(.title)
                            }
                            Spacer()
                            Button { viewStore.send(.togglePlayback) } label: {
                                Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                                    .font(.largeTitle)
                                    .frame(minWidth: 60)
                            }
                            Spacer()
                            Button { viewStore.send(.forward) } label: {
                                Image(systemName: "forward.fill")
                                    .font(.title)
                            }
                            Spacer()
                        }
                        .frame(minHeight: 60)
                        HStack {
                            Spacer()
                            Button {
                                viewStore.send(.toggleShuffle)
                            } label: {
                                Image(systemName: "shuffle")
                                    .foregroundColor(viewStore.isShuffleOn ? .primary : .secondary)
                            }
                            Spacer()
                            Button {
                                viewStore.send(.toggleRepeat)
                            } label: {
                                Image(systemName: viewStore.isRepeatOneOn ?  "repeat.1" : "repeat")
                                    .foregroundColor(viewStore.isRepeatOn ? .primary : .secondary)
                            }
                            Spacer()
                        }
                        AirPlayButton()
                    }
                }
                .padding(.horizontal, 16)
                .foregroundColor(.primary)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image(systemName: "minus")
                            .imageScale(.large)
                            .font(Font.title.weight(.heavy))
                            .foregroundColor(.secondary)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct PlaybackDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlaybackDetailView(
            store:  Store<PlaybackDetailState, PlaybackDetailAction>(
                initialState: PlaybackDetailState(
                    properties: PlaybackProperties(
                        playbackState: .playing,
                        repeatMode: .none,
                        shuffleMode: .default,
                        nowPlayingItem: LibraryItem.playlistItems.first!
                    )
                ),
                reducer: playbackDetailReducer,
                environment: PlaybackDetailEnvironment(
                    mainQueue: .main,
                    playbackProperties: { return .none },
                    togglePlayback: { return .none },
                    toggleShuffle: { return .none },
                    toggleRepeat: { return .none },
                    forward: { return .none },
                    backward: { return .none }
                )
            )
        )
    }
}
