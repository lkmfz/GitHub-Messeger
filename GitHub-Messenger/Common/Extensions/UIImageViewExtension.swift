//
//  UIImageViewExtension.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 3/3/2020.
//

import UIKit

public extension UIImageView {

    /// To download and set the image from a URL
    /// - Parameter url: image URL
    /// - Parameter placeholder: image placeholder
    func loadImage(from url: String?, placeholder: UIImage? = nil) {
        guard let url = url, let imageURL = URL(string: url) else {
            self.image = placeholder
            return
        }

        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)

        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }).resume()
        }
    }
}
