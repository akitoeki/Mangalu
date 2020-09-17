//
//  HomeView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI



struct HomeView: View {
    @State var popularTitles: [Title] = []
    @State var lastestTitles: [Title] = []
    @State var randomTitles: [Title] = []
    @State var portal: PortalPreference?
    @State var isShowing: Bool = false
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
        
        ZStack {
            VStack {
                NavigationView {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            TitleList(listName: "Popular", titles: popularTitles)
                            TitleList(listName: "Lastest", titles: lastestTitles)
                            TitleList(listName: "Discover", titles: randomTitles)
                            Spacer()
                            Button(action: {
                                self.isShowing = true
                            }) {
                                Text("Test")
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    

                    }
                    .navigationBarTitle(Text("Trending").font(.system(.largeTitle, design: .monospaced)), displayMode: .large)
                    .portal(isShowing: self.$isShowing) {
                        Text("POrtal working")
                    }
                    
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
                .onPreferenceChange(PortalPreferenceKey.self) { (value) in
                    self.portal = value
                }
            }
            if (self.portal != nil) {
                Color(.darkGray)
                self.portal!.content()
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

