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
    var from: Int
    var to: Int
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
    var alternate_title: String?
    var description: String?
    var image_url: String
    var thumb_url: String
    var status: String
    var tags: [Tag]
}

class ReadManhwaAPI {
    var nsfw = false
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
}

let api = ReadManhwaAPI()
