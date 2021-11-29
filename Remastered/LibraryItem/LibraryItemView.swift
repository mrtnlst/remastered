//
//  LibraryItemView.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import SwiftUI
import ComposableArchitecture

// TODO: Clean Up!
struct LibraryItemView: View {
    let store: Store<LibraryItemState, LibraryItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                headerView(for: viewStore.item)
                playButton { viewStore.send(.didSelectItem(id: viewStore.item.id)) }
                trackList(for: viewStore.item.items())
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension LibraryItemView {
    @ViewBuilder func playButton(_ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: "play.fill")
                Text("Play")
                    .bold()
            }
            .foregroundColor(.primary)
            .padding()
        }
    }
    @ViewBuilder func headerView(for collection: LibraryCollection) -> some View {
        VStack {
            if let image = collection.artwork() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .frame(maxHeight: 180)
            }
            Text(collection.title)
                .font(.headline)
                .foregroundColor(.primary)
            Text("by \(collection.artist)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    @ViewBuilder func trackList(for items: [LibraryItem]) -> some View {
        VStack {
            Divider()
            ForEach(items) { item in
                VStack {
                    HStack {
                        Text("\(item.track)")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: 20)
                        Text(item.title)
                            .font(.body)
                            .lineLimit(1)
                        Spacer(minLength: 16)
                        Text(item.formattedDuration)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 16)
                    }
                    .padding(.init(arrayLiteral: .top, .bottom), 4)
                    Divider()
                        .padding(.leading, 28)
                }
            }
        }
        .padding(.leading , 24)
    }
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryItemView(
                store: Store(
                    initialState: LibraryItemState(item: LibraryCollection.exampleAlbums.first!),
                    reducer: libraryItemReducer,
                    environment: LibraryItemEnvironment()
                )
            )
        }
    }
}
