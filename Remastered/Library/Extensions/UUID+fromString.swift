//
//  UUID+fromString.swift
//  Remastered
//
//  Created by martin on 24.12.21.
//

import CryptoKit
import Foundation

extension UUID {
    static func customUUID(from string: String?) -> UUID? {
        guard let string = string else {
            return nil
        }
        let namespace = "com.martinlist.Remastered"
        let fullString = namespace + string
        
        let hash = Insecure.SHA1.hash(data: Data(fullString.utf8))
        var truncatedHash = Array(hash.prefix(16))
        truncatedHash[6] &= 0x0F    // Clear version field
        truncatedHash[6] |= 0x50    // Set version to 5

        truncatedHash[8] &= 0x3F    // Clear variant field
        truncatedHash[8] |= 0x80    // Set variant to DCE 1.1
        let uuidString = NSUUID(uuidBytes: truncatedHash).uuidString
        return UUID(uuidString: uuidString)
    }
}
