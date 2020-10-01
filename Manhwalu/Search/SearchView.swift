//
//  SearchView.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/30/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State var searchValue: String = ""
    var searchTimer: Timer?

    
    @StateObject var searchModel: SearchModel = SearchModel()
    var body: some View {
        UITextField.appearance().clearButtonMode = .whileEditing
        
        return NavigationView {
            ScrollView() {
                VStack(alignment: .center, spacing: 10) {
                    TextField("Search Term", text: $searchValue) { _ in } onCommit: {
                        if (searchValue.caseInsensitiveCompare("nsfw") == .orderedSame) {
//                            self.settings.nsfw = !UserDefaults.standard.bool(forKey: "nsfw")
                            UserDefaults.standard.setValue(!UserDefaults.standard.bool(forKey: "nsfw"), forKey: "nsfw")
                            
                        }
                        self.searchModel.search(query: self.searchValue)
                    }
                    .font(.body)
                    .padding(6)
                    .background(Color(.systemGray5))
                    .cornerRadius(6)
                    .frame(height: 20)
                    .padding(.bottom, 20)
                    
                    if searchValue == "" {
                        HStack {
                            Text("RECENT")
                                .font(.headline)
                            Spacer()
                            Button("CLEAR", action: {})
                                .accentColor(Color.primaryText)
                                .font(.subheadline)
                        }
                    }
                    
                    if searchValue != "" {
                        if searchModel.isSearching {
                            Text("Searching...")
                                .font(.subheadline)
                        } else {
//                            if searchValue.caseInsensitiveCompare("nsfw") == .orderedSame {
//                                Text("Nsfw Mode is \(settings.nsfw ? "On" : "Off")")
//                                    .font(.subheadline)
//                            }
                            if (searchModel.results.count == 0 && searchValue == searchModel.searchQuery) {
                                Text("No Result")
                                    .font(.subheadline)
                            }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200))]) {
                                ForEach(self.searchModel.results, id: \.id) { title in
                                    NavigationLink(
                                        destination: TitleDetailView(title: title),
                                        label: {
                                            TitleView(title: title, preferredCoverHeight: 250)
                                        }
                                    )
                                    .accentColor(.primaryText)
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding(.all, 20)
            }
            .navigationTitle("Search")
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
