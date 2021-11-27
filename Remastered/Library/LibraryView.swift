//
//  LibraryView.swift
//  Remastered
//
//  Created by martin on 13.11.21.
//

import SwiftUI
import CombineSchedulers
import ComposableArchitecture

struct LibraryView: View {
    let store: Store<LibraryState, LibraryAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEach(viewStore.albums) { album in
                        Button {
                            viewStore.send(LibraryAction.didSelectItem(id: album.id))
                        } label: {
                            HStack {
                                if let image = album.artwork {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 50)
                                        .cornerRadius(4)
                                } else {
                                    Image(systemName: "rectangle.stack.fill")
                                }
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .foregroundColor(.black)
                                    Text(album.artist)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Library")
            }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(
            store:
                Store(
                    initialState: LibraryState(albums: LibraryAlbum.exampleAlbums),
                    reducer: libraryReducer,
                    environment: LibraryEnvironment(mainQueue: .main, fetch: { return .none })
                )
        )
    }
}
