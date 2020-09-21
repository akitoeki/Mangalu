//
//  TitleView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI


struct TagView: View {
    var name: String = ""
    
    var body: some View {
        Text(name)
            .font(.caption)
            .padding(.horizontal, 4)
            .background(Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.2))
            .foregroundColor(.gray)
            .cornerRadius(2)
    }
}
struct TitleView: View {
    var title: Title
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(title: Title) {
        self.title = title
        self.urlImageModel = UrlImageModel(urlString: title.image_url)
    }
    
    static func topTags(tags: [Tag], max: Int) -> [Tag] {
        let cutoff = tags.count >= max ? max : tags.count
        guard cutoff > 0 else {
            return []
        }
        return Array(tags[0...cutoff-1])
        
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(uiImage: urlImageModel.image ?? TitleView.defaultImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 210)
                .cornerRadius(4)
            Text("\(title.title)")
                .font(.caption)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .padding(0)
                .frame(width: 150, alignment: .topLeading)
            
            HStack(alignment: .top, spacing: 4) {
                ForEach(TitleView.topTags(tags: title.tags, max: 2), id: \.id) { tag in
                    TagView(name: tag.name)
                }
            }
        }.frame(width: 160, height: 280, alignment: .top)
    }
    
    static var defaultImage = UIImage(named: "poster-placeholder")
}

struct TitleView_Previews: PreviewProvider {
    
    static var previews: some View {
        TitleView(title: dummy_title)
    }
}
