//
//  IGDocument.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 24.08.2020.
//

import UIKit

class IGDocument: UIDocument {
    
    var gallery: IGGallery?
    var thumbnail: UIImage?
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            self.gallery = IGGallery.fromJSON(json)
        }
    }
    
    override func fileAttributesToWrite(to url: URL, for operation: UIDocument.SaveOperation)throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: operation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }
    
}
