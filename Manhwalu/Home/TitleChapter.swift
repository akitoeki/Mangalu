//
//  TitleChapter.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/20/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct TitleChapter: View {
    var chapter: Chapter
    var body: some View {
        HStack {
            Image(systemName: "book")
                .font(.system(size: 14, weight: .light, design: .default))
            Button(action: {}, label: {
                Text(chapter.name)
                    .font(.callout)
                    
            })
            .accentColor(.primaryText)
            Spacer()
            Text(chapter.added_at)
                .font(.footnote)
                .foregroundColor(.gray)
            Button(action: {}, label: {
                Image(systemName: "arrow.down.circle")
                    .font(.system(size: 14, weight: .light, design: .default))
            })
        }
        .padding(EdgeInsets(top: 3, leading: 20, bottom: 3, trailing: 20))
        
    }
}

struct TitleChapterList: View {
    var chapters: [Chapter] = []
    var body: some View {
        VStack {
            HStack {
                Text("Chapters")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Georgia-Bold", size: 20))
                    .padding(.bottom, 10)
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "tray.and.arrow.down")
                        .font(.system(size: 12, weight: .medium, design: .default))
                    Text("Download")
                        .font(.footnote)
                })
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(Color(.systemGray5))
                .cornerRadius(4)
            }.padding(.horizontal, 20)
            
            ForEach(chapters, id: \.id) { chapter in
                TitleChapter(chapter: chapter)
            }
        }
    }
}

struct TitleChapter_Previews: PreviewProvider {
    static var previews: some View {
        TitleChapterList(chapters: [dummy_chapter, dummy_chapter])
    }
}
