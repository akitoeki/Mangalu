//
//  TitleDetailView.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/18/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct TitleDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var title: Title
    @ObservedObject var urlImageModel: UrlImageModel
    var defaultImage = UIImage(named: "poster-placeholder")
    
    init(title: Title) {
        self.title = title
        self.urlImageModel = UrlImageModel(urlString: title.image_url)
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: true){
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
                Image(uiImage: urlImageModel.image ?? TitleView.defaultImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 420)
                    .cornerRadius(4)
                    .shadow(color: Color.gray.opacity(0.2), radius: 30, x: 0, y: 10)
                    .frame(width: 200, height: 320)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 10)
                    .frame(width: 300, height: 420)
                
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        
        
    }
}

struct TitleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TitleDetailView(title: dummy_title)
            .environment(\.colorScheme, .dark)
    }
}
