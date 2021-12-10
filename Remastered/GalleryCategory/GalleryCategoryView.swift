//
//  GalleryCategoryView.swift
//  Remastered
//
//  Created by martin on 05.12.21.
//

import SwiftUI
import ComposableArchitecture

struct GalleryCategoryView: View {
    let store: Store<GalleryCategoryState, GalleryCategoryAction>
    let columns = [GridItem(spacing: 16), GridItem(spacing: 16)]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEachStore(store.scope(
                        state: \.items,
                        action: GalleryCategoryAction.libraryItem(id:action:))
                    ) { libraryStore in
                        NavigationLink {
                            LibraryItemView(store: libraryStore)
                        } label: {
                            ArtworkView(
                                collection: ViewStore(libraryStore).item,
                                cornerRadius: 8
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(viewStore.type.rawValue)
        }
    }
}

struct GalleryCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GalleryCategoryView(
                store: Store(
                    initialState: GalleryCategoryState.exampleCategories.first!,
                    reducer: galleryCategoryReducer,
                    environment: GalleryCategoryEnvironment()
                )
            )
        }
    }
}
