//
//  CustomTopNav.swift
//  Manhwalu
//
//  Created by Nhan Dang on 9/21/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct CustomTopNav: View {    
    var title: String = "Test"
    var visible: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            ZStack(alignment:.bottom) {
                VisualEffectView(effect: UIBlurEffect(style: colorScheme == .dark ? .dark : .light))
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 24))
                            .padding()
                    })
                    Spacer()
                    Text(title)
                        .font(.custom("Georgia-Bold", size: 18))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                        .padding(.trailing)
                        .minimumScaleFactor(0.3)
                        
                }
                
            }
            .frame(width: screen.width, height: 90, alignment: .bottom)
            .background(Rectangle().fill(Color.backgroundColor.opacity(0.5)).blur(radius: 3))
            .accentColor(.primaryText)
            .transition(.opacity)
            .opacity(visible ? 1 : 0)
        }        
    }
}

struct CustomTopNav_Previews: PreviewProvider {
    static var previews: some View {
        CustomTopNav()
    }
}
