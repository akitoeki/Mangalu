//
//  HomeView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct HomeView: View {
    @Namespace var namespace
    @ObservedObject private var homeModel: HomeModel = HomeModel()
    @State var portal: PortalPreference?
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 32)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 16)!]        
    }
    
    var body: some View {
        ZStack {
            Color(.black)
            VStack {
                NavigationView {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            TitleList(listName: "Popular", titles: self.homeModel.popularTitles, namespace: namespace)
                            TitleList(listName: "Lastest", titles: self.homeModel.lastestTitles, namespace: namespace)
                            TitleList(listName: "Discover", titles: self.homeModel.randomTitles, namespace: namespace)
                                
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                    .navigationBarTitle("Trending", displayMode: .large)
                }
                .onAppear {
                    homeModel.loadData()
                }
                .onPreferenceChange(PortalPreferenceKey.self) { (value) in
                    self.portal = value
                }
                .zIndex(1)
//                .brightness(self.portal != nil ? -0.2 : 0)
//                .animation(.default, value: self.portal)
                
                
                
            }.environmentObject(homeModel)
            
//            if (self.portal != nil) {
//                self.portal!.content()
//            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

