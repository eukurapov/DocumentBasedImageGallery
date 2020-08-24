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
            if window != nil && url != oldValue && activityIndicator?.isAnimating ?? false {
                fetchImage()
            }
        }
    }
    var completionHandler: (() -> Void)?
    private var activityIndicator: UIActivityIndicatorView?
    
    func fetchImage() {
        self.image = nil
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator?.hidesWhenStopped = true
        activityIndicator!.center = self.superview?.center ?? self.center
        self.addSubview(activityIndicator!)
        if let urlToFetch = self.url {
            let request = URLRequest(url: urlToFetch, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            self.activityIndicator?.startAnimating()
            print("started for \(urlToFetch.absoluteString)")
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    if urlToFetch == self.url {
                        self.activityIndicator?.stopAnimating()
                        print("stopped for \(urlToFetch.absoluteString)")
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
