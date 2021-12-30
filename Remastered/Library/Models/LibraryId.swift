//
//  LibraryId.swift
//  Remastered
//
//  Created by martin on 30.12.21.
//

import Foundation

struct LibraryId: Equatable {
    let persistentId: String
    
    init?(_ persistentId: String?) {
        if let persistentId = persistentId {
            self.persistentId = persistentId
        } else {
            return nil
        }
    }
    
    var uuid: UUID {
        return UUID.customUUID(from: persistentId)
    }
}
