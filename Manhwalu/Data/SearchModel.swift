//
//  SearchModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 10/1/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

class SearchModel: ObservableObject {
    @Published var results: [Title] = []
    @Published var isSearching: Bool = false
    @Published var searchQuery: String? = nil
    func search(query: String) {
        isSearching = true
        api.search(query: query) { (data) in
            self.searchQuery = query
            DispatchQueue.main.async {
                self.isSearching = false
                self.results = data
            }
        }
    }
}
