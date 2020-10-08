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
    var hasNew: Bool = false
    var preferredCoverHeight: CGFloat
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(title: Title, preferredCoverHeight: CGFloat =  220, hasNew: Bool = false) {
        self.title = title
        self.preferredCoverHeight = preferredCoverHeight
        self.hasNew = hasNew
        self.urlImageModel = UrlImageModel(urlString: title.image_url, persist: true)
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
                .scaledToFit()
                .overlay(VStack {
                    if hasNew {
                        Text("New")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(2)
                            .background(Color.red)
                            .shadow(radius: 2 )
                        
                    }
                }, alignment: .topTrailing)
                
                .cornerRadius(4)
                .overlay(
                    Image("book-mask")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.4)
                , alignment: .leading)
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0.0, y: 4)
                
                
            VStack(alignment: .leading, spacing: 4){
                Text("\(title.title)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.top, 10)
                    .frame(width: 150, alignment: .bottomLeading)
                
                HStack(alignment: .top, spacing: 4) {
                    ForEach(TitleView.topTags(tags: title.tags, max: 2), id: \.id) { tag in
                        TagView(name: tag.name)
                    }
                }
            }.frame(height: 80, alignment: .topLeading)
            
        }
        
    }
    
    static var defaultImage = UIImage(named: "poster-placeholder")
}

struct TitleView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            TitleView(title: dummy_title)
            TitleView(title: dummy_title, preferredCoverHeight: 250, hasNew: true)
                .previewLayout(.fixed(width: 150, height: 600))
                
        }
    }
}
