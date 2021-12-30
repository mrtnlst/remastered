//
//  ArtworkView.swift
//  Remastered
//
//  Created by martin on 08.12.21.
//

import SwiftUI
import ComposableArchitecture

struct ArtworkView: View {
    enum ArtworkType {
        case collection(LibraryCollection?)
        case item(LibraryItem?)
    }
    
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let type: ArtworkType
    
    init(with type: ArtworkType, cornerRadius: CGFloat, shadowRadius: CGFloat = 0) {
        self.type = type
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
  
    var body: some View {
        switch type {
        case let .collection(collection):
            if let artwork = collection?.artwork() {
                singleArtworkView(for: artwork, with: cornerRadius)
            } else if collection?.type == .playlist {
                let artworks = collection?.tiledArtworks() ?? []
                switch artworks.count {
                case 0:
                    placeholderArtworkView(with: cornerRadius)
                case 1:
                    singleArtworkView(for: artworks[0], with: cornerRadius)
                default:
                    tiledArtworkView(for: artworks, with: cornerRadius)
                }
            } else if collection?.type == .genre {
                EmptyView()
            } else {
                placeholderArtworkView(with: cornerRadius)
            }
        case let .item(item):
            if let artwork = item?.artwork() {
                singleArtworkView(for: artwork, with: cornerRadius)
            } else {
                placeholderArtworkView(with: cornerRadius)
            }
        }
    }
    
    @ViewBuilder func singleArtworkView(
        for artwork: UIImage,
        with cornerRadius: CGFloat
    ) -> some View {
        Image(uiImage: artwork)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(cornerRadius)
            .shadow(radius: shadowRadius)
    }
    
    @ViewBuilder func tiledArtworkView(
        for artworks: [UIImage],
        with cornerRadius: CGFloat
    ) -> some View {
        // TODO: This is not optimal, but a LazyGridView added layout issues.
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(uiImage: artworks[0])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(uiImage: artworks[1])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            HStack(spacing: 0) {
                Image(uiImage: artworks[2])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Image(uiImage: artworks[3])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .cornerRadius(cornerRadius)
        .shadow(radius: shadowRadius)
    }
    
    @ViewBuilder func placeholderArtworkView(
        with cornerRadius: CGFloat
    ) -> some View {
        Image(systemName: "questionmark.square.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(cornerRadius)
            .foregroundColor(.secondary)
    }
}

struct ArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArtworkView(
                with: .collection(LibraryCollection.exampleAlbums.first!),
                cornerRadius: 8
            )
            ArtworkView(
                with: .collection(LibraryCollection.exampleAlbums.last!),
                cornerRadius: 8
            )
            ArtworkView(
                with: .collection(LibraryCollection.exampleAlbums[1]),
                cornerRadius: 8
            )
            ArtworkView(
                with: .collection(
                    LibraryCollection(
                        type: .genre,
                        title: "",
                        subtitle: "",
                        dateAdded: Date()
                    )
                ),
                cornerRadius: 8
            )
        }
    }
}
