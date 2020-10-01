//
//  Viewer.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/22/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI


struct ViewerImage: View {
    var imgUrl: String
    @StateObject var urlImageModel: UrlImageModel
    init(imgUrl: String) {
        self.imgUrl = imgUrl
        self._urlImageModel = StateObject(wrappedValue: UrlImageModel(urlString: imgUrl))
    }
    var body: some View {
        Image(uiImage: urlImageModel.image ?? TitleView.defaultImage!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: screen.width, alignment: .top)
            .frame(minHeight: 20)
    }
}

struct ViewerHeader: View {
    var title: String = "Title Name"
    var chapter: String = "Chapter Name"
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var onNext: () -> Void = {}
    var onPrev: () -> Void = {}
    
    var hasNext: Bool = false
    var hasPrev: Bool = false
    
    var body: some View {
        HStack {
            ZStack(alignment:.bottom) {
                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .padding()
                    })
                    VStack(alignment: .leading){
                        Text(chapter)
                            .font(.custom("Georgia-Bold", size: 12))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(2)
                            .padding(.trailing)
                            .minimumScaleFactor(0.3)
                        Text(title)
                            .font(.custom("Georgia-Bold", size: 14))
                            .multilineTextAlignment(.trailing)
                            .lineLimit(2)
                            .padding(.trailing)
                            .minimumScaleFactor(0.3)
                    }
                    
                    Spacer()
                    Button(action: onPrev, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .padding()
                    })
                    .disabled(!hasPrev)
                    .opacity(hasPrev ? 1 : 0.2)
                    
                    Button(action: onNext, label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                            .padding()
                    })
                    .disabled(!hasNext)
                    .opacity(hasNext ? 1 : 0.2)
                }
            }
            .frame(width: screen.width, height: 90, alignment: .bottom)
            .accentColor(.primaryText)
        }
    }
}
struct Viewer: View {
    var allChapters: [Chapter]
    var title: Title
    
    @StateObject var chapterModel: ChapterModel
    @State var showHeader = true
    
    init(chapter: Chapter, allChapters: [Chapter], title: Title) {
        self.title = title
        self.allChapters = allChapters
        self._chapterModel = StateObject(wrappedValue: ChapterModel(title: title, chapter: chapter, allChapters: allChapters))
    }
    
    
    var body: some View {
        ZStack(alignment: .top) {
            if (chapterModel.chapterDetail != nil) {
                ScrollView {
                    VStack (alignment: .center, spacing: 0) {
                        ForEach(chapterModel.chapterDetail!.images, id: \.id) { image in
                            ViewerImage(imgUrl: image.source_url)
                        }
                        
                    }
                    .frame(width: screen.width)
                }
                .zIndex(1)
                .onTapGesture(perform: {
                    withAnimation(.easeInOut){
                        self.showHeader.toggle()
                        
                    }
                })
            }
            
            if showHeader {
                ViewerHeader(
                    title: title.title,
                    chapter: self.chapterModel.currentChapter.name,
                    onNext: self.chapterModel.goNext,
                    onPrev: self.chapterModel.goPrev,
                    hasNext: self.chapterModel.nextChapter != nil,
                    hasPrev: self.chapterModel.prevChapter != nil
                )
                .transition(.opacity)
                .zIndex(2)
            }
            
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
        .navigationTitle("")
        .frame(width: screen.width, height: screen.height, alignment: .top)
        .onAppear(perform: {
            self.chapterModel.loadCurrent()
        })
        
    }
    
}

struct Viewer_Previews: PreviewProvider {
    static var previews: some View {
        Viewer(chapter: dummy_chapter,  allChapters: [dummy_chapter, dummy_chapter], title: dummy_title)
    }
}
