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

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                GalleryListView(store: store)
                    .navigationBarTitle("Gallery")
            }
            .searchable(text: viewStore.binding(\.$searchText))
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            store: Store(
                initialState: GalleryState(categories: LibraryCategoryState.exampleGalleryCategories),
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
