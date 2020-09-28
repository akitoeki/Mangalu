//
//  UrlImageModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: String?) {
        self.urlString = urlString
        self.loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()        
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            DispatchQueue.main.async {
                guard let loadedImage = UIImage(data: data) else {
                    return
                }
                self.imageCache.set(forKey: urlString, image: loadedImage)
                self.image = loadedImage
            }
        }.resume()
    }
        
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
