//
//  ChapterModel.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/22/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI
import CoreData

class ChapterModel: ObservableObject {
    var title: Title
    var allChapters: [Chapter]
    @Published var nextChapter: Chapter? = nil
    @Published var prevChapter: Chapter? = nil
    
    @Published var currentChapter: Chapter
    @Published var chapterDetail: ChapterDetail? = nil
    @Published var isChapterDetailLoading = false
    @Published var isChapterDetailLoaded = false
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(title: Title, chapter: Chapter, allChapters: [Chapter]) {
        self.title = title
        self.currentChapter = chapter
        self.allChapters = allChapters
        self.calcNextPrev()
        self.setRead()
    }
    
    func setRead() {
        let request:NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
        request.predicate = NSPredicate(format: "title_id == %d AND current_chapter_id == %d", title.id, currentChapter.id)
        
        if let result = try? context.fetch(request) {
            print(result)
            if result.count == 0 {
                print("Wasn't bookmarked before")
                //If it wasn't read before
                let newBookmark = Bookmark(context: context)
                newBookmark.current_chapter_id = Int32(currentChapter.id)
                newBookmark.current_chapter_slug = currentChapter.slug
                newBookmark.image_url = title.image_url
                newBookmark.title_id = Int32(title.id)
                newBookmark.title_slug = title.slug
                newBookmark.date = Date()
            } else {
                print("Already Bookmarked, updating date")
                result.forEach { (bookmark) in
                    bookmark.setValue(Date(), forKey: "date")
                }
            }
            do {
                try context.save()
            } catch let error as NSError {
                print(error)
            }
        }
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
        self.currentChapter = chapter
        self.calcNextPrev()
        self.setRead()
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
        API.main.getChapterImages(titleSlug: title.slug, chapterSlug: currentChapter.slug) { (chapterDetail) in
            DispatchQueue.main.async {
                self.chapterDetail = chapterDetail
                self.isChapterDetailLoading = false
                self.isChapterDetailLoaded = true
            }            
        }
    }
}
