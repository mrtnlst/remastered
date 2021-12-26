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
                ScrollView(.vertical, showsIndicators: true) {
                    ForEachStore(
                        store.scope(
                            state: \.rows,
                            action: GalleryAction.galleryRowAction(id:action:)
                        )
                    ) { rowStore in
                        GalleryRowView(store: rowStore)
                    }
                }
                .padding(.horizontal)
                .navigationBarTitle("Gallery")
            }
        }
    }
}



struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            store: Store(
                initialState: GalleryState(rows: LibraryCategoryState.exampleGalleryRows),
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
