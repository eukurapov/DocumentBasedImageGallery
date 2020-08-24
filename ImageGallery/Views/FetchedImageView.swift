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
            if window != nil {
                fetchImage()
            }
        }
    }
    var completionHandler: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    
    func fetchImage() {
        self.image = nil
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator!.center = self.superview?.center ?? self.center
        self.addSubview(activityIndicator!)
        if let urlToFetch = self.url {
            activityIndicator?.startAnimating()
            let request = URLRequest(url: urlToFetch, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
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
