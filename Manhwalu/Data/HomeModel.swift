//
//  HomeModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/18/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import Foundation
import SwiftUI
class HomeModel: ObservableObject {
    @Published var isLoaded = false
    @Published var popularTitles: [Title] = []
    @Published var isLoadingPopular = false
    
    @Published var lastestTitles: [Title] = []
    @Published var isLoadingLatest = false
    
    @Published var randomTitles: [Title] = []
    @Published var isLoadingRandom = false
    
    func loadData (force: Bool = false) {
        guard (!isLoaded || force) else {
            print("Loaded from cache")
            return
        }
        self.isLoaded = false
        
        
        if !isLoadingLatest {
            self.isLoadingLatest = true
            API.main.getLastesTitles { (titles) in
                DispatchQueue.main.async {
                    self.lastestTitles = titles
                    self.isLoadingLatest = false
                    self.checkAllLoaded()
                }
            }
        }
        
        if !isLoadingPopular {
            self.isLoadingPopular = true
            API.main.getPopularTitles { (titles) in
                DispatchQueue.main.async {
                    self.popularTitles = titles
                    self.isLoadingPopular = false
                    self.checkAllLoaded()
                }
            }
        }
        
        if !isLoadingRandom {
            self.isLoadingRandom = true
            API.main.getRandomTitles { (titles) in
                DispatchQueue.main.async {
                    self.randomTitles = titles
                    self.isLoadingRandom = false
                    self.checkAllLoaded()
                }
            }
        }
        
        
    }
    
    func checkAllLoaded() {
        guard (!isLoadingPopular && !isLoadingRandom && !isLoadingLatest ) else {
            return
        }
        isLoaded = true
    }
    
}
