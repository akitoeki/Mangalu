//
//  TitleModel.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/19/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI


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
            API.main.getTitleDetail(slug: title.slug) { (detail) in
                DispatchQueue.main.async {
                    self.titleDetail = detail
                    self.isDetailLoaded = true
                    self.isDetailLoading = false
                }                
            }
        }
        
        if (!isChapterLoading) {
            isChapterLoading = true
            API.main.getTitleChapters(slug: title.slug) { (chapters) in
                DispatchQueue.main.async {
                    self.chapters = chapters
                    self.isChapterLoaded = true
                    self.isChapterLoading = false
                }
            }
        }
        
        if (!isRecommendationLoaded && !isReccomendationLoading) {
            isReccomendationLoading = true
            API.main.getTitleChapters(slug: title.slug) { (chapters) in
                DispatchQueue.main.async {
                    self.chapters = chapters
                    self.isChapterLoaded = true
                    self.isChapterLoading = false
                }
            }
        }
    }
    
}
