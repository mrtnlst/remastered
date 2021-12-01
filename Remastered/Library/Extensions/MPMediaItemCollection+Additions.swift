//
//  MPMediaItemCollection+Additions.swift
//  Remastered
//
//  Created by martin on 14.11.21.
//

import MediaPlayer

extension MPMediaItemCollection {
    
    var dateAdded: Date? { representativeItem?.dateAdded }
    
    var artist: String? { representativeItem?.artist }
    
    var isFavorite: Bool { return items.contains { $0.rating > 3 } }
    
    var numberOfItems: String { items.count == 1 ? "\(items.count) song" : "\(items.count) songs" }
    
    var lastPlayed: Date? {
        let defaultDate = Date(timeIntervalSince1970: 0)
        return items
            .sorted { $0.lastPlayedDate ?? defaultDate > $1.lastPlayedDate ?? defaultDate }
            .first?.lastPlayedDate
    }
    
    var artwork: UIImage? {
        let image = representativeItem?.artwork
        return image?.image(at: CGSize(width: 100, height: 100))
    }
    
    var catalogArtwork: UIImage? {
        // TODO: Obfuscate!
        let sel = NSSelectorFromString("bestImageFromDisk")
        guard let catalog = value(forKey: "artworkCatalog") as? NSObject,
              catalog.responds(to: sel),
              let value = catalog.perform(sel)?.takeUnretainedValue(),
              let image = value as? UIImage
        else { return artwork }
        return image
    }
}
