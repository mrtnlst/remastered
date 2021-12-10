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
                .padding(.init(arrayLiteral: .leading, .trailing), 16)
                .multilineTextAlignment(.center)
            Text(collection.type == .albums ? "by \(collection.subtitle)" : "\(collection.subtitle)")
                .font(.caption)
                .foregroundColor(.secondary)
            ArtworkView(collection: collection, cornerRadius: 8)
                .frame(maxHeight: 180)
                .reflection(offsetY: 10)
        }
    }
    
    @ViewBuilder func trackList(for items: [LibraryItem], in collection: LibraryCollection) -> some View {
        VStack {
            cloudItemRow(collection.isCloudItem)
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
                            Spacer()
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
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryItemView(
                store: Store(
                    initialState: LibraryItemState(item: LibraryCollection.exampleAlbums.last!),
                    reducer: libraryItemReducer,
                    environment: LibraryItemEnvironment()
                )
            )
        }
    }
}
