//
//  GalleryView.swift
//  Remastered
//
//  Created by martin on 27.11.21.
//

import SwiftUI
import CombineSchedulers
import ComposableArchitecture


struct GalleryView: View {
    let store: Store<GalleryState, GalleryAction>
    let rows = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(store.scope(
                        state: \.categories,
                        action: GalleryAction.galleryCategory(id:action:))
                    ) { store in
                        galleryRow(with: store)
                    }
                }
                .navigationBarTitle("Gallery")
            }
        }
    }
}

extension GalleryView {
    
    @ViewBuilder func galleryRow(with store: Store<GalleryCategoryState, GalleryCategoryAction>) -> some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                NavigationLink {
                    GalleryCategoryView(store: store)
                } label: {
                    Text(viewStore.type.rawValue)
                        .font(.headline)
                }
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: rows, alignment: .center, spacing: 16) {
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
                                    .frame(maxHeight: 80)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            store: Store(
                initialState: GalleryState(categories: GalleryCategoryState.exampleCategories),
                reducer: galleryReducer,
                environment: GalleryEnvironment(
                    mainQueue: .main,
                    fetch: { return .none },
                    uuid: { UUID.init() }
                )
            )
        )
    }
}
