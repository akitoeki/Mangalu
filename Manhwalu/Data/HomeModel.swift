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
    @Published var isLoading = false
    @Published var namespace: Namespace.ID = Namespace().wrappedValue
    @Published var popularTitles: [Title] = []
    @Published var isLoadingPopular = false
    
    @Published var lastestTitles: [Title] = []
    @Published var isLoadingLatest = false
    
    @Published var randomTitles: [Title] = []
    @Published var isLoadingRandom = false
    
    func loadData (force: Bool = false) {
        guard (!isLoaded || force) else {
            return
        }
        self.isLoaded = false
        self.isLoading = false
        self.isLoadingLatest = true
        self.isLoadingRandom = true
        self.isLoadingPopular = true
        
        api.getLastesTitles { (titles) in
            self.lastestTitles = titles
            self.isLoadingLatest = false
            self.checkAllLoaded()
        }
        api.getPopularTitles { (titles) in
            self.popularTitles = titles
            self.isLoadingPopular = false
            self.checkAllLoaded()
        }
        api.getRandomTitles { (titles) in
            self.randomTitles = titles
            self.isLoadingRandom = true
            self.checkAllLoaded()
        }
    }
    
    func checkAllLoaded() {
        guard isLoading else {
            return
        }
        guard (isLoadingPopular || isLoadingRandom || isLoadingLatest ) else {
            return
        }
        isLoading = false
        isLoaded = true
    }
    
    func setNamespace(namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
