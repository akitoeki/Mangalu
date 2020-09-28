//
//  TitleDetailView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/18/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

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
    @ObservedObject var titleModel: TitleModel
    var title: Title
    @State var seeMore: Bool = false
    @ObservedObject var urlImageModel: UrlImageModel
    var defaultImage = UIImage(named: "poster-placeholder")
    
    init(title: Title) {
        self.title = title
        self.titleModel = TitleModel(title: self.title)
        self.urlImageModel = UrlImageModel(urlString: title.image_url)
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geometry in
                CustomTopNav(title: self.title.title, visible: geometry.frame(in: .global).minY < -400)
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
                        Button(action: {}, label: {
                            HStack {
                                Image(systemName: "suit.heart")
                                Text("Add to Library")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.accentColor, lineWidth: 2)
                                
                            )
                        })
                        
                        Button(action: {}, label: {
                            Image(systemName: "book")
                            Text("Read Now")
                                .font(.subheadline)
                        })
                        .padding(.vertical, 12)
                        .padding(.horizontal, 26)
                        .background(Color.orange)
                        .accentColor(.white)
                        .cornerRadius(30)
                        
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
                
                
                TitleChapterList(chapters: titleModel.chapters, title: title)
                
            }
        }
        .accentColor(.primaryText)
        .navigationBarHidden(true)
        .navigationTitle("")
        .onAppear {
            titleModel.loadData()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct TitleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDetailView(title: dummy_title)
        
    }
}
