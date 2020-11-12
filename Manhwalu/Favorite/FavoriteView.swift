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
            return favorites.map { (fav) -> Title in
                return try! JSONDecoder().decode(Title.self, from: fav.cached_title!)
            }
        }
    }
    
    func checkForUpdates() {
        favorites.forEach { (favObj) in
            if Date().timeIntervalSince(favObj.last_update_check!) > 300 {
                API.main.getTitleDetail(slug: favObj.slug!) { (title) in
                    favObj.last_update_check = Date()
                    if (favObj.chapter_count < title.chapters_count) {
                        print("Should Update")
                        favObj.has_new = true
                        favObj.chapter_count = Int16(title.chapters_count)
                        if let data = try? JSONEncoder().encode(title) {
                            favObj.cached_title = data
                        }
                    }
                    DispatchQueue.main.async {
                        do {
                            try managedObjectContext.save()
                        } catch let error as NSError {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func decodeTitle(data: Data) -> Title {
        return try! JSONDecoder().decode(Title.self, from: data)
    }
    var body: some View {
        print("RERENDERED")
        return NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 250), spacing: 20)], alignment: .leading, spacing: 20){
                    ForEach(favorites) { item -> AnyView in
                        let title = decodeTitle(data: item.cached_title!)
                        return AnyView(NavigationLink(
                            destination: TitleDetailView(title: title),
                            label: {
                                TitleView(title: title, preferredCoverHeight: 250, hasNew: item.has_new)
                            }
                        )
                        .accentColor(.primaryText))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationBarTitle("Favorites", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            checkForUpdates()
        })
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .preferredColorScheme(.dark)
    }
}
