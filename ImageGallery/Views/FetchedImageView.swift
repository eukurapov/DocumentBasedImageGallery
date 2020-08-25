//
//  FetchedImageView.swift
//  ImageGallery
//
//  Created by Eugene Kurapov on 20.08.2020.
//

import UIKit

class FetchedImageView: UIImageView {
    
    var url: URL? {
        didSet {
            if window != nil, url != nil && url != oldValue && activityIndicator?.isAnimating ?? false {
                fetchImage()
            }
        }
    }
    var completionHandler: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    
    override var bounds: CGRect {
        didSet {
            activityIndicator?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    func fetchImage() {
        self.image = nil
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.center = CGPoint(
            x: (superview?.bounds.width ?? bounds.width) / 2,
            y: (superview?.bounds.height ?? bounds.height) / 2)
        self.addSubview(activityIndicator!)
        if let urlToFetch = self.url {
            let request = URLRequest(url: urlToFetch, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            self.activityIndicator?.startAnimating()
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if urlToFetch == self.url {
                        self.activityIndicator?.stopAnimating()
                        if error == nil, data != nil, let fetchedImage = UIImage(data: data!) {
                            self.image = fetchedImage
                        }  else {
                            self.contentMode = .center
                            let errorImage = UIImage(systemName: "xmark.octagon")?.withTintColor(.red).resized(for: self.errorImageSize)
                            self.center = self.superview?.center ?? self.center
                            self.image = errorImage
                        }
                        self.completionHandler?()
                    }
                }
            }.resume()
        }
    }
    
    private let errorImageSize = CGSize(width: 40, height: 36)

}
