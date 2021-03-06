//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Evgeniy Kurapov on 14.08.2020.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var url: URL? {
        get { imageView.url }
        set {
            imageView.url = newValue
            if newValue != nil {
                imageView.fetchImage()
            }
        }
    }
    
    @IBOutlet weak var imageView: FetchedImageView!
    
}
