//
//  TitleModel.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/19/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct TitleDetail: Codable, Identifiable {
    let id: Int
    var title: String
    var chapters_count: Int
    var slug: String
    var alternate_title: String?
    var description: String?
    var image_url: String
    var thumb_url: String
    var tags: [Tag]
    var artists: [Person]
    var authors: [Person]
}

struct Person: Identifiable, Codable {
    var id: Int
    var comics_count: Int
    var image_url: String
    var name: String
    var slug: String
}

struct Chapter: Codable, Identifiable{
    var id: Int
    var added_at: String
    var name: String
    var read: Bool
    var slug: String
}
class TitleModel: ObservableObject {
    var title: Title
    @Published var titleDetail: TitleDetail? = nil
    @Published var isDetailLoading: Bool = false
    @Published var isDetailLoaded: Bool = false
    
    @Published var chapters: [Chapter] = []
    @Published var isChapterLoading: Bool = false
    @Published var isChapterLoaded: Bool = false
    
    @Published var recomendations: [Title] = []
    @Published var isReccomendationLoading: Bool = false
    @Published var isRecommendationLoaded: Bool = false
    
    init(title: Title) {
        self.title = title
    }
    
    func loadData() {
                
        if (!isDetailLoaded && !isDetailLoading) {
            isDetailLoading = true
            api.getTitleDetail(slug: title.slug) { (detail) in
                self.titleDetail = detail
                self.isDetailLoaded = true
                self.isDetailLoading = false
            }
        }
        
        if (!isChapterLoading) {
            isChapterLoading = true
            api.getTitleChapters(slug: title.slug) { (chapters) in
                self.chapters = chapters
                self.isChapterLoaded = true
                self.isChapterLoading = false
            }
        }
        
        if (!isRecommendationLoaded && !isReccomendationLoading) {
            isReccomendationLoading = true
            api.getTitleChapters(slug: title.slug) { (chapters) in
                self.chapters = chapters
                self.isChapterLoaded = true
                self.isChapterLoading = false
            }
        }
    }
}