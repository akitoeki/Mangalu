//
//  API.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI


struct PaginatedResult<T: Codable>: Codable {
    var total: Int
    var current_page: Int
    var data: T
    var from: Int?
    var to: Int?
}

struct Tag: Codable, Identifiable {
    let id: Int
    var comics_count: Int
    var color: String
    var description: String?
    var name: String
}

struct Title: Codable, Identifiable {
    let id: Int
    var title: String
    var chapter_count: Int?
    var slug: String
    var alternate_title: String?
    var description: String?
    var image_url: String
    var thumb_url: String    
    var tags: [Tag]
}

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

struct ChapterDetail: Codable {
    var chapter: Chapter
    var images: [ChapterImage]
}

struct ChapterImage: Codable, Identifiable {
    var id: Int
    var page: Int
    var source_url: String
    var thumbnail_url: String
}

class ReadManhwaAPI {
    var nsfw = UserDefaults.standard.bool(forKey: "nsfw")
    
    func getPopularTitles(completion: @escaping ([Title]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics?sort=popularity&duration=week&per_page=24&nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode(PaginatedResult<[Title]>.self, from: data!)
            completion(res.data)
        }.resume()
    }
    func getLastesTitles(completion: @escaping ([Title]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics?latest=true&per_page=24&nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode([Title].self, from: data!)
            completion(res)
        }.resume()
    }
    func getRandomTitles(completion: @escaping ([Title]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics?discover=true&per_page=24&nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode([Title].self, from: data!)
            completion(res)
        }.resume()
    }
    func getTitleDetail(slug: String, completion: @escaping (TitleDetail) -> ()) {
        print("https://readmanhwa.com/api/comics/\(slug)&nsfw=\(nsfw)")
        let url = URL(string: "https://readmanhwa.com/api/comics/\(slug)?nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
        
            let res = try! JSONDecoder().decode(TitleDetail.self, from: data!)
            completion(res)
        }.resume()
    }
    func getTitleChapters(slug: String, completion: @escaping ([Chapter]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics/\(slug)/chapters?nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode([Chapter].self, from: data!)
            completion(res)
        }.resume()
    }
    
    func getRecommendationForTitle(slug: String, completion: @escaping ([Chapter]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics/\(slug)/chapters?nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode([Chapter].self, from: data!)
            completion(res)
        }.resume()
    }
    
    func getChapterImages(titleSlug: String, chapterSlug: String, completion: @escaping (ChapterDetail) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics/\(titleSlug)/\(chapterSlug)/images?nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode(ChapterDetail.self, from: data!)
            completion(res)
        }.resume()
    }
    
    func search(query: String, completion: @escaping ([Title]) -> ()) {
        let url = URL(string: "https://readmanhwa.com/api/comics?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&per_page=12&nsfw=\(nsfw)")
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            let res = try! JSONDecoder().decode(PaginatedResult<[Title]>.self, from: data!)
            completion(res.data)
        }.resume()
    }
}

let api = ReadManhwaAPI()
