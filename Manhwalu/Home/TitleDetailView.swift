//
//  TitleDetailView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/18/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI
import CoreData

struct HorizontalLineShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))
        
        return path
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 1.0
    
    init(color: Color, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: 0, maxWidth: .infinity, minHeight: height, maxHeight: height)
    }
}


struct TitleDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @StateObject var titleModel: TitleModel
    var title: Title
    @State var seeMore: Bool = false
    @ObservedObject var urlImageModel: UrlImageModel
    var defaultImage = UIImage(named: "poster-placeholder")
    
    @State var showViewer: Bool = false
    
    
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    @FetchRequest var bookmarks: FetchedResults<Bookmark>
    
    init(title: Title) {
        self.title = title
        self._titleModel = StateObject(wrappedValue: TitleModel(title: title))
        self.urlImageModel = UrlImageModel(urlString: title.image_url, persist: true)
        self._bookmarks = FetchRequest(entity: Bookmark.entity(), sortDescriptors: [NSSortDescriptor(key: "date", ascending: false)], predicate: NSPredicate(format: "title_id == %d", title.id), animation: .default)
    }
    
    func isFavorited() -> Bool {        
        return (favorites.first(where: {fav in
            return fav.title_id == self.title.id
        }) != nil)
    }
    
    func onReadChapter() {
        
    }
        
    
    var body: some View {
        return ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                CustomTopNav(title: self.title.title, visible: true)
                    .opacity(Double((-100 - geometry.frame(in: .global).minY) / 100))
                    .offset(y: -geometry.frame(in: .global).minY )
            }
            .frame(height: 0)
            .zIndex(100)
            
            VStack {
                //Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .padding()
                    })
                    Spacer()
                }
                .padding(.top, 50)
                Group {
                    Image(uiImage: urlImageModel.image ?? TitleView.defaultImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 420)	
                        .cornerRadius(4)
                        .shadow(color: Color.black.opacity(0.2), radius: 30, x: 0, y: 10)
                        .frame(width: 200, height: 320)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 10)
                        .frame(width: 300, height: 420)
                        .overlay(
                            Image("book-mask")
                                .resizable()
                                .frame(width: 24, height: 420, alignment: .leading)
                                .opacity(0.4)
                        , alignment: .leading)
                    
                    HStack {
                        ForEach(TitleView.topTags(tags: title.tags, max: 5), id: \.id) { tag in
                            TagView(name: tag.name)
                        }
                    }
                    .padding(.top, 10)
                    
                    Text(title.title)
                        .font(.custom("Georgia-Bold", size: 26))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 4.0)
                    if (title.alternate_title != nil) {
                        Text(title.alternate_title!)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            isFavorited() ? removeFromFavorite() : addToFavorite()
                        }, label: {
                            HStack {
                                Image(systemName: isFavorited() ? "heart.slash" : "suit.heart")
                                Text(isFavorited() ? "Remove from Library" : "Add to Library")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            )
                        })
                        
                        Button(action: {
                            self.showViewer.toggle()
                            
                        }, label: {
                            Image(systemName: "book")
                            Text(bookmarks.first != nil ? "Continue" : "Read Now")
                                .font(.subheadline)
                        })
                        .disabled(titleModel.chapters.count == 0)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 26)
                        .background(Color.orange)
                        .accentColor(.white)
                        .cornerRadius(30)
                        .fullScreenCover(isPresented: $showViewer, content: {
                            Viewer(
                                chapter: (bookmarks.first != nil ? titleModel.chapters.first(where: {$0.slug == bookmarks.first!.current_chapter_slug})!
                                            : titleModel.chapters.last!),
                                allChapters: titleModel.chapters, title: title
                            )
                        })
                        
                    }
                    .padding(.vertical, 15)
                }
                
                
                HorizontalLine(color: Color(.systemGray5))
                    .padding(20)
                
                if (title.description != nil) {
                    Text("Description")
                        .frame(width: screen.width - 40, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Georgia-Bold", size: 15))
                        .padding(.bottom, 10)
                    
                    Text("\(title.description!)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(seeMore ? 100: 5)
                        .padding(.horizontal, 20)
                        .foregroundColor(.gray)
                        .frame(width: screen.width, alignment: .topLeading)
                        .onTapGesture {
                            withAnimation {
                                self.seeMore.toggle()
                            }
                        }
                    
                }
                
                HorizontalLine(color: Color(.systemGray5))
                    .padding(20)
                
                
                TitleChapterList(chapters: titleModel.chapters, title: title, seenChapters: self.bookmarks.map({ (b) -> Int in
                    return Int(b.current_chapter_id)
                }))
                .onAppear {
                    titleModel.loadData()
                }
                
            }
        }
        
        .accentColor(.primaryText)
        .navigationBarHidden(true)
        .navigationTitle("")
        
        .edgesIgnoringSafeArea(.all)
    }
    
    func removeFromFavorite() {
        if let obj = favorites.first(where: {$0.title_id == title.id}) {
            managedObjectContext.delete(obj)
        }
    }
    
    func addToFavorite() {
        let newFav = Favorite(context: managedObjectContext)
        if let data = try? JSONEncoder().encode(title) {
            newFav.cached_title = data
        }
        newFav.title_id = Int32(title.id)
        if let chapter_count = title.chapter_count {
            newFav.chapter_count = Int16(chapter_count)
        }
        newFav.has_new = false
        newFav.title = title.title
        newFav.image_url = title.image_url
        newFav.slug = title.slug
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
        
    }
}

struct TitleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDetailView(title: dummy_title)
        
    }
}
