//
//  FavoriteView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/30/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 32)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 16)!]
    }
    
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 20)], alignment: .leading, spacing: 20){
                    ForEach(0 ..< 10) { item in
                        TitleView(title: dummy_title, preferredCoverHeight: 250.0)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitle("Favorites", displayMode: .large)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .preferredColorScheme(.dark)
    }
}
