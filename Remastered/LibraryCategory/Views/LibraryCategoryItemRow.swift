//
//  LibraryCategoryItemRow.swift
//  Remastered
//
//  Created by martin on 13.12.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryCategoryItemRow: View {
    let store: Store<LibraryItemState, LibraryItemAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                ArtworkView(collection: viewStore.item, cornerRadius: 4)
                    .frame(maxHeight: 50)
                VStack(alignment: .leading) {
                    Text(viewStore.item.title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(viewStore.item.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    if viewStore.item.isCloudItem {
                        Image(systemName: "cloud")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                Spacer(minLength: 8)
            }
            .padding(.vertical, 5)
        }
    }
}

struct LibraryCategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        LibraryCategoryItemRow(
            store: Store(
                initialState: LibraryCategoryState.exampleLibraryPlaylists.first!,
                reducer: libraryItemReducer,
                environment: LibraryItemEnvironment()
            )
        )
    }
}
