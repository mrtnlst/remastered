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
                VStack {
                    if let image = viewStore.item.artwork {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(8)
                            .frame(maxHeight: 180)
                    }
                    Text(viewStore.item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("by \(viewStore.item.artist)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Button {
                    viewStore.send(.didSelectItem(id: viewStore.item.id))
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play")
                            .bold()
                    }
                    .foregroundColor(.white)
                    .padding(.init(arrayLiteral: .top, .bottom), 8)
                    .padding(.init(arrayLiteral: .leading, .trailing), 16)
                    .background {
                        Color.secondary
                            .opacity(0.4)
                    }
                    .cornerRadius(8)
                }
                Divider()
                ForEach(viewStore.item.items) { item in
                    HStack {
                        Text("\(item.track)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text(item.title)
                            .font(.body)
                        Spacer()
                    }
                    .padding(.init(arrayLiteral: .top, .bottom), 4)
                    
                    Divider()
                }
                .padding(.leading , 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
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
