//
//  LibraryItemView.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryItemView: View {
    let store: Store<LibraryItemState, LibraryItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                headerView(for: viewStore.item)
                playButton {
                    viewStore.send(.didSelectItem(id: viewStore.item.id, type: viewStore.item.type))
                }
                trackList(for: viewStore.item.items(), in: viewStore.item)
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
            Text(collection.title)
                .font(.headline)
                .foregroundColor(.primary)
            Text("by \(collection.subtitle)")
                .font(.caption)
                .foregroundColor(.secondary)
            ArtworkView(collection: collection, height: 180, cornerRadius: 8)
                .reflection(offsetY: 10)
        }
    }
    @ViewBuilder func trackList(for items: [LibraryItem], in collection: LibraryCollection) -> some View {
        VStack {
            Divider()
            ForEach(items) { item in
                VStack {
                    Button {
                        ViewStore(store).send(.didSelectItem(id: collection.id, type: collection.type, position: item.track))
                    } label: {
                        HStack {
                            Text("\(item.track)")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: 30)
                            Text(item.title)
                                .font(.body)
                                .lineLimit(1)
                                .foregroundColor(.primary)
                            Spacer(minLength: 16)
                            Text(item.formattedDuration)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.trailing, 16)
                        }
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
