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
            ScrollView(.vertical, showsIndicators: true) {
                headerView(for: viewStore.collection)
                playButton {
                    viewStore.send(.didSelectItem(id: viewStore.collection.libraryId.persistentId, type: viewStore.collection.type))
                }
                trackList(for: viewStore.collection.items(), in: viewStore.collection)
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
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .multilineTextAlignment(.center)
            Text(collection.type == .album ? "by \(collection.subtitle)" : "\(collection.subtitle)")
                .font(.caption)
                .foregroundColor(.secondary)
            ArtworkView(with: .collection(collection), cornerRadius: 8, shadowRadius: 3)
                .frame(maxHeight: 180)
                .reflection(offsetY: 10)
        }
    }
    
    @ViewBuilder func trackList(for items: [LibraryItem], in collection: LibraryCollection) -> some View {
        VStack {
            cloudItemRow(collection.isCloudItem)
            Divider()
            LazyVStack {
                ForEach(items) { item in
                    switch collection.type {
                    case .album:
                        albumRow(for: item, in: collection)
                    default:
                        genericRow(for: item, in: collection)
                    }
                }
            }
        }
        .padding(.leading , 24)
        .padding(.bottom, 80)
    }
    
    @ViewBuilder func cloudItemRow(_ isCloudItem: Bool) -> some View {
        if isCloudItem {
            HStack {
                Spacer()
                Image(systemName: "cloud")
                    .foregroundColor(.secondary)
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
            }
        }
    }
    
    @ViewBuilder func genericRow(for item: LibraryItem, in collection: LibraryCollection) -> some View {
        VStack(spacing: 4) {
            Button {
                ViewStore(store).send(.didSelectItem(
                    id: collection.libraryId.persistentId,
                    type: collection.type,
                    startItem: item.libraryId.persistentId)
                )
            } label: {
                HStack {
                    ArtworkView(
                        with: .item(item),
                        cornerRadius: 4,
                        shadowRadius: 2
                    )
                        .frame(maxHeight: 40)
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.body)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                        if let artist = item.artist {
                            Text("by \(artist.name)")
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer(minLength: 16)
                    Spacer()
                    Text(item.formattedDuration)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 16)
                }
            }
            Divider()
                .padding(.leading, 48)
        }
    }
    
    @ViewBuilder func albumRow(for item: LibraryItem, in collection: LibraryCollection) -> some View {
        VStack(spacing: 8) {
            Button {
                ViewStore(store).send(.didSelectItem(
                    id: collection.libraryId.persistentId,
                    type: collection.type,
                    startItem: item.libraryId.persistentId)
                )
            } label: {
                HStack(alignment: .center) {
                    // TODO: The width should be calculated
                    Text("\(item.track)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 24)
                    Text(item.title)
                        .font(.callout)
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    Spacer(minLength: 16)
                    Spacer()
                    Text(item.formattedDuration)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.trailing, 16)
                }
            }
            .padding(.vertical, 2)
            Divider()
                .padding(.leading, 32)
        }
    }
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryItemView(
                store: Store(
                    initialState: LibraryItemState(collection: LibraryCollection.examplePlaylists.last!),
                    reducer: libraryItemReducer,
                    environment: LibraryItemEnvironment()
                )
            )
        }
        NavigationView {
            LibraryItemView(
                store: Store(
                    initialState: LibraryItemState(collection: LibraryCollection.exampleAlbums.last!),
                    reducer: libraryItemReducer,
                    environment: LibraryItemEnvironment()
                )
            )
        }
    }
}
