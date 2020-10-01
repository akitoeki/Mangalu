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
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: []) var favorites: FetchedResults<Favorite>
    var favs: [Title] {
        get {
            print(favorites)
            return favorites.map { (fav) -> Title in
                return try! JSONDecoder().decode(Title.self, from: fav.cached_title!)
            }
        }
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 250), spacing: 20)], alignment: .leading, spacing: 20){
                    ForEach(favs) { item in
                        NavigationLink(
                            destination: TitleDetailView(title: item),
                            label: {
                                TitleView(title: item, preferredCoverHeight: 250)
                            }
                        )
                        .accentColor(.primaryText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationBarTitle("Favorites", displayMode: .large)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear()
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .preferredColorScheme(.dark)
    }
}
