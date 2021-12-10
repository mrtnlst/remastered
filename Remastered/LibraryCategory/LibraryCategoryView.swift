//
//  LibraryCategoryView.swift
//  Remastered
//
//  Created by martin on 28.11.21.
//

import SwiftUI
import ComposableArchitecture

struct LibraryCategoryView: View {
    let store: Store<LibraryCategoryState, LibraryCategoryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEachStore(store.scope(
                    state: \.items,
                    action: LibraryCategoryAction.libraryItem(id:action:))
                ) { store in
                    NavigationLink {
                        LibraryItemView(store: store)
                    } label: {
                        itemRow(from: ViewStore(store).item)
                    }
                }
            }
            .navigationBarTitle(viewStore.type.rawValue)
        }
    }
}

extension LibraryCategoryView {
    @ViewBuilder func itemRow(from collection: LibraryCollection) -> some View {
        HStack {
            ArtworkView(collection: collection, cornerRadius: 4)
                .frame(maxHeight: 50)
            VStack(alignment: .leading) {
                Text(collection.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(collection.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "cloud")
                .foregroundColor(collection.isCloudItem ? .secondary : .clear)
        }
        .padding(.init(arrayLiteral: .bottom, .top), 5)
    }
}

struct LibraryCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LibraryCategoryView(
                store: Store(
                    initialState: LibraryCategoryState.exampleCategories.first!,
                    reducer: libraryCategoryReducer,
                    environment: LibraryCategoryEnvironment()
                )
            )
        }
    }
}
