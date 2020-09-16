//
//  ContentView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/16/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        TabView(selection: $selection){
            HomeView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image("trending")
                            .renderingMode(.template)
                        Text("Trending")
                    }
                    .padding(.top, 4)
            }
            .tag(0)
            
            Text("Library")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("library")
                            .renderingMode(.template)
                        Text("Library")
                    }
            }
            .tag(1)
            
            Text("Discover")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("explore")
                            .renderingMode(.template)
                        Text("Discover")
                    }
            }
            .tag(2)
            
            Text("Search")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("search")
                            .renderingMode(.template)
                        Text("Search")
                    }
            }
            .tag(3)
        }
        .edgesIgnoringSafeArea(.top)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}
