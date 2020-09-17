//
//  TitleList.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/17/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct TitleList: View {
    var listName: String
    var titles: [Title]
    @State var showDetail = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(listName)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.bold)
                .padding(.horizontal)
            if (titles.count > 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(titles, id: \.id) { title in
                            TitleView(title: title, showDetail: self.$showDetail)                                
                        }
                    }                    
                    .padding(.all)
                    .padding(.top, 30)
                }
                .offset(y: -30)
            }
        }.frame(width: screen.width, height: 320, alignment: .topLeading)
    }
}
struct TitleList_Previews: PreviewProvider {
    static var previews: some View {
        TitleList(listName: "Test 123", titles: dummy_titles)
    }
}
