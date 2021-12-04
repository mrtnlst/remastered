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
                    ForEach(viewStore.galleryRowModels) { model in
                        galleryRow(with: viewStore, model: model)
                    }
                }
                .navigationBarTitle("Gallery")
            }
        }
    }
}

extension GalleryView {
    
    @ViewBuilder func galleryRow(with viewStore: ViewStore<GalleryState, GalleryAction>, model: GalleryRowModel) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.type.rawValue)
                    .font(.headline)
                Spacer()
                Button { } label: {
                    HStack(spacing: 4) {
                        Text("Show all")
                            .font(.caption2)
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                    }
                    .foregroundColor(.primary)
                }
            }
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: rows, alignment: .center, spacing: 16) {
                    ForEach(model.items) { item in
                        if let image = item.artwork() {
                            Button {
                                viewStore.send(.didSelectItem(id: item.id, type: item.type))
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 80)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            store:
                Store(
                    initialState: GalleryState(galleryRowModels: GalleryRowModel.exampleRowModels),
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
