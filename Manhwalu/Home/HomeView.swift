//
//  HomeView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI


struct TitleList: View {
    var listName: String
    var titles: [Title]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(listName)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.bold)
                .padding(.horizontal)
            if (titles.count > 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(titles, id: \.id) { title in
                            TitleView(title: title)
                        }
                    }
                    .padding(.all)
                }
            }
            
        }
    }
}

struct HomeView: View {
    @State var popularTitles: [Title] = []
    @State var lastestTitles: [Title] = []
    @State var randomTitles: [Title] = []
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 32)!]
        
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 16)!]
    }
    init(popularTitles: [Title], lastestTitles: [Title]) {
        self.init()
        self.popularTitles = popularTitles
        self.lastestTitles = lastestTitles
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    TitleList(listName: "Popular", titles: popularTitles)
                    TitleList(listName: "Lastest", titles: lastestTitles)
                    TitleList(listName: "Discover", titles: randomTitles)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)

            }
            .navigationBarTitle(Text("Trending").font(.system(.largeTitle, design: .monospaced)), displayMode: .large)
            
        }
        .onAppear {
            print("RERENDERED")
            api.getLastesTitles { (titles) in
                self.lastestTitles = titles
            }
            api.getPopularTitles { (titles) in
                self.popularTitles = titles
            }
            api.getRandomTitles { (titles) in
                self.randomTitles = titles
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        TitleList(listName: "Popular", titles: dummy_titles)
    }
}

