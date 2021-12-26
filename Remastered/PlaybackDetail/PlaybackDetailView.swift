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
        WithViewStore(store) { viewStore in
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    Image(systemName: "minus")
                        .imageScale(.large)
                        .font(Font.title.weight(.heavy))
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    Text(viewStore.libraryItem?.title ?? "None")
                        .font(.headline)
                    // TODO: use artwork view
                    if let artwork = viewStore.libraryItem?.artwork() {
                        Image(uiImage: artwork)
                            .resizable()
                            .cornerRadius(8)
                            .aspectRatio(contentMode: .fit)
                            .padding()
                    }
                    Text("by Artist")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ProgressView()
                        .progressViewStyle(LinearProgressViewStyle())
                    HStack {
                        Spacer()
                        Button { viewStore.send(.backward) } label: { Image(systemName: "backward.fill") }
                        Spacer()
                        Button { viewStore.send(.togglePlayback) } label: {
                            Image(systemName: viewStore.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                        }
                        Spacer()
                        Button { viewStore.send(.forward) } label: { Image(systemName: "forward.fill") }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button { } label: { Image(systemName: "shuffle") }
                        Spacer()
                        Button { } label: { Image(systemName: "repeat") }
                        Spacer()
                    }
                    VStack {
                        Slider(value: $volume, in: -100...100)
                    }
                }
            }
            .padding(.horizontal)
            .foregroundColor(.primary)
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
                    forward: { return .none },
                    backward: { return .none }
                )
            )
        )
    }
}
