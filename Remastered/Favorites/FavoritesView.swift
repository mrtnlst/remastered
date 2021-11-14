//
//  FavoritesView.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesView: View {
    let store: Store<FavoritesState, FavoritesAction>
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewStore.favorites) { card in
                        ZStack {
                            Image(systemName: "rectangle.stack.fill")
                                .resizable()
                                .scaledToFill()
                            Text(card.albumTitle)
                                .foregroundColor(.white)
                                .font(.caption2)
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(
            store: Store(
                initialState: FavoritesState(favorites: LibraryAlbum.exampleAlbums),
                reducer: favoritesReducer,
                environment: FavoritesEnvironment(
                    favoritesService: FavoritesService()
                )
            )
        )
    }
}
