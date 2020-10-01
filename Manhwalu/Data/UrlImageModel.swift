//
//  UrlImageModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI
import CoreData

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    var imageCache = ImageCache.getImageCache()
    var persistImageCache = PersistentImageCache.getImageCache()
    var persist: Bool
    
    init(urlString: String?, persist: Bool = false) {
        self.urlString = urlString
        self.persist = persist
        self.loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        if loadImageFromPersistentCache() {
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
    
    func loadImageFromPersistentCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        guard let cacheImage = persistImageCache.get(forKey: urlString) else {
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
                if (self.persist) {
                    self.persistImageCache.set(forKey: urlString, image: loadedImage)
                }
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


class PersistentImageCache {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    func get(forKey: String) -> UIImage? {
        let request: NSFetchRequest<CachedImage> = CachedImage.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", forKey)
        
        if let result = try? context.fetch(request) {
            if (result.count > 0) {
                return UIImage(data: result.first!.data!)
            }
        }
        return nil
    }
    
    func set(forKey: String, image: UIImage) {
        let request: NSFetchRequest<CachedImage> = CachedImage.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", forKey)
        
        if let result = try? context.fetch(request) {
            if (result.count > 0) {
                result.first!.setValue(image.pngData(), forKey: "data")
            } else {
                let newImageCache = CachedImage(context: context)
                newImageCache.data = image.pngData()
                newImageCache.url = forKey
            }
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        }
        
    }
}

extension PersistentImageCache {
    private static var imageCache = PersistentImageCache()
    static func getImageCache() -> PersistentImageCache {
        return imageCache
    }
}

