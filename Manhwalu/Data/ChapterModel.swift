//
//  ChapterModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/22/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

class ChapterModel: ObservableObject {
    var title: Title
    var allChapters: [Chapter]
    @Published var nextChapter: Chapter? = nil
    @Published var prevChapter: Chapter? = nil
    
    @Published var currentChapter: Chapter
    @Published var chapterDetail: ChapterDetail? = nil
    @Published var isChapterDetailLoading = false
    @Published var isChapterDetailLoaded = false
    
    init(title: Title, chapter: Chapter, allChapters: [Chapter]) {
        self.title = title
        self.currentChapter = chapter
        self.allChapters = allChapters
        self.calcNextPrev()
    }
    
    func calcNextPrev() {
        let index = self.allChapters.firstIndex(where: {c in c.id == currentChapter.id})
        if let current = index {
            if current > 0 {
                self.nextChapter = self.allChapters[current - 1]
            } else {
                self.nextChapter = nil
            }
            if current < self.allChapters.count - 1 {
                self.prevChapter = self.allChapters[current + 1]
            } else {
                self.prevChapter = nil
            }
        }
    }
    
    func setCurrentChapter(chapter: Chapter) {
        currentChapter = chapter
        calcNextPrev()
    }
    
    func goNext() {
        guard self.nextChapter != nil else {
            return
        }
        self.setCurrentChapter(chapter: self.nextChapter!)
        self.chapterDetail = nil
        self.loadChapter(next: self.currentChapter)
    }
    func goPrev() {
        guard self.prevChapter != nil else {
            return
        }
        self.setCurrentChapter(chapter: self.prevChapter!)
        self.chapterDetail = nil
        self.loadChapter(next: self.currentChapter)
    }
    
    
    func loadChapter(next: Chapter) {
        self.currentChapter = next
        self.isChapterDetailLoaded = false
        self.isChapterDetailLoading = false
        self.loadCurrent()
    }
    func loadCurrent() {
        guard isChapterDetailLoading != true && isChapterDetailLoaded != true else {
            return
        }
        isChapterDetailLoading = true
        api.getChapterImages(titleSlug: title.slug, chapterSlug: currentChapter.slug) { (chapterDetail) in
            self.chapterDetail = chapterDetail
            self.isChapterDetailLoading = false
            self.isChapterDetailLoaded = true
        }
    }
}
