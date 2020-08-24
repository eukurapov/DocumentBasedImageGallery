//
//  IGGallery.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 18.08.2020.
//

import Foundation

class IGGallery: Codable {
    
    var images = [IGImage]()
    
    private var isRemoved = false
    var isActive: Bool { !isRemoved }
    
    func remove() {
        isRemoved = true
    }
    
    func restore() {
        isRemoved = false
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func fromJSON(_ json: Data) -> IGGallery? {
        return try? JSONDecoder().decode(self, from: json)
    }
    
}
