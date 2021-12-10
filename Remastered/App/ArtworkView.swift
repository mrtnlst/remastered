//
//  ArtworkView.swift
//  Remastered
//
//  Created by martin on 08.12.21.
//

import SwiftUI
import simd

struct ArtworkView: View {
    let collection: LibraryCollection
    let height: CGFloat
    let cornerRadius: CGFloat
  
    var body: some View {
        if let artwork = collection.artwork() {
            singleArtworkView(for: artwork, of: height, with: cornerRadius)
        } else if collection.type == .playlists {
            let artworks = collection.tiledArtworks()
            switch artworks.count {
            case 0:
                placeholderArtworkView(of: height, with: cornerRadius)
            case 1:
                singleArtworkView(for: artworks[0], of: height, with: cornerRadius)
            default:
                tiledArtworkView(for: artworks, of: height, with: cornerRadius)
            }
        } else {
            placeholderArtworkView(of: height, with: cornerRadius)
        }
    }
    
    @ViewBuilder func singleArtworkView(
        for artwork: UIImage,
        of height: CGFloat,
        with cornerRadius: CGFloat
    ) -> some View {
        Image(uiImage: artwork)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(cornerRadius)
            .frame(maxHeight: height)
    }
    
    @ViewBuilder func tiledArtworkView(
        for artworks: [UIImage],
        of height: CGFloat,
        with cornerRadius: CGFloat
    ) -> some View {
        let item: GridItem = .init(.adaptive(minimum: 50), spacing: 0)
        LazyHGrid(rows: [item, item], spacing: 0) {
            ForEach(artworks, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .cornerRadius(cornerRadius)
        .frame(maxHeight: height)
    }
    
    @ViewBuilder func placeholderArtworkView(
        of height: CGFloat,
        with cornerRadius: CGFloat
    ) -> some View {
        Image(systemName: "questionmark.square.dashed")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(cornerRadius)
            .foregroundColor(.primary)
            .frame(maxHeight: height)
    }
}

struct ArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ArtworkView(
                collection: LibraryCollection.exampleAlbums.first!,
                height: 180,
                cornerRadius: 8
            )
            ArtworkView(
                collection: LibraryCollection.exampleAlbums.last!,
                height: 180,
                cornerRadius: 8
            )
            ArtworkView(
                collection: LibraryCollection(
                    type: .genres,
                    title: "",
                    artist: "",
                    dateAdded: Date()
                ),
                height: 180,
                cornerRadius: 8
            )
        }
    }
}
