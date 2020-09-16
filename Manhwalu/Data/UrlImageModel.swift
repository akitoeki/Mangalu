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
    
    init(urlString: String?) {
        self.urlString = urlString
        self.loadImage()
    }
    
    func loadImage() {
        loadImageFromUrl()        
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
                self.image = loadedImage
            }
        }.resume()
    }
        
}
