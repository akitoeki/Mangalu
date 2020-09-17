//
//  Portal.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/17/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct Portal<Presenting: View, Content: View>: View {
    @Binding var isShowing: Bool
    var presenting: Presenting
    var content: Content
    init(isShowing: Binding<Bool>, @ViewBuilder presenting: () -> Presenting, @ViewBuilder content: () -> Content) {
        self._isShowing = isShowing
        self.presenting = presenting()
        self.content = content()
    }
    var body: some View {
        ZStack(alignment: .center) {
            self.presenting
                .blur(radius: self.isShowing ? 1 : 0)
            VStack {
                self.content
            }
        }
    }
}

struct PortalPreference: Equatable, Identifiable {
    let id = UUID()
    let content: () -> AnyView
    let shouldDismiss: () -> Bool
    let resetBinding: () -> Void
    
    static func == (lhs: PortalPreference, rhs: PortalPreference) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PortalPreferenceKey: PreferenceKey {
    typealias Value = PortalPreference?
    static var defaultValue: Value = nil
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let result = nextValue() ?? value
        value = result
    }
}

struct PortalModifier<PortalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> PortalContent
    
    func portal() -> PortalPreference {
        PortalPreference (
            content: {AnyView(self.content())},
            shouldDismiss: { !self.isPresented },
            resetBinding: { self.isPresented = false }
        )
    }
    
    func body(content: Content) -> some View {
        content
            .preference(key: PortalPreferenceKey.self, value: isPresented ? self.portal() : nil)
    }
}


extension View {
    func portal<Content:View>(isShowing: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(PortalModifier(isPresented: isShowing, content: content))
    }
}
