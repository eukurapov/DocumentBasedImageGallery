//
//  Extensions.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 24.08.2020.
//

import Foundation
import UIKit
import AVFoundation

extension UIImage {
    
    func resized(for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}

extension URLCache {
    static func configSharedCache(directory: String? = Bundle.main.bundleIdentifier, memory: Int = 0, disk: Int = 0) {
        URLCache.shared = {
            let cacheDirectory = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String).appendingFormat("/\(directory ?? "cache")/" )
            return URLCache(memoryCapacity: memory, diskCapacity: disk, diskPath: cacheDirectory)
        }()
    }
}

extension ImageGalleryCollectionViewController {
    
    var snapshot: UIImage? {
        var images = [UIImage]()
        let maxImages = min(8, collectionView.numberOfItems(inSection: 0))
        for i in 0..<maxImages {
            if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? ImageCollectionViewCell,
                let image = cell.imageView.image {
                images.append(image)
            }
        }
        guard !images.isEmpty else { return nil }
        
        if images.count == 1 {
            return images.first!
        }
        
        let rect = CGRect(x: 0, y: 0, width: 1024, height: 1024)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)

        let heightOfSubImage: CGFloat = rect.height / 2
        let widthOfSubImage = rect.width / 2
        
        for (index, image) in images.enumerated() {
            let evenMultiplier = CGFloat(index % 2 == 0 ? -1 : 1)
            
            let rectToDrawIn = AVMakeRect(aspectRatio: image.size,
                                          insideRect: CGRect(
                                            x: rect.minX + evenMultiplier * (-40) + widthOfSubImage * CGFloat(index % 2),
                                            y: rect.minY - 40 + heightOfSubImage * 0.6 * CGFloat(index / 2),
                                            width: widthOfSubImage,
                                            height: heightOfSubImage))
            let context = UIGraphicsGetCurrentContext()!
            // Get the center of new image
            let center = CGPoint(x: rectToDrawIn.midX, y: rectToDrawIn.midY)
            // Set center of image as context action point, so rotation works right
            context.translateBy(x: center.x, y: center.y)
            context.saveGState()
            // Rotate the context
            let angle = evenMultiplier * CGFloat.pi*30/180
            context.rotate(by: angle)
            // Context origin is image's center. So should draw image on point on origin
            image.draw(in: CGRect(origin: CGPoint(x: -rectToDrawIn.size.width/2, y: -rectToDrawIn.size.height/2), size: rectToDrawIn.size))
            // Go back to context original state.
            context.rotate(by: -angle)
            context.translateBy(x: -center.x, y: -center.y)
            context.saveGState()
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return outputImage
    }
    
}
