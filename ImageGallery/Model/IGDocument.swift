//
//  IGDocument.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 24.08.2020.
//

import UIKit

class IGDocument: UIDocument {
    
    var gallery: IGGallery?
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            self.gallery = IGGallery.fromJSON(json)
        }
    }
    
}
