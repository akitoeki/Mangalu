//
//  Portal.swift
//  Manhwalu
//
//  Created by VND Dang, Nhan on 9/17/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

struct PortalPreference: Equatable, Identifiable {
    let id = UUID()
    let content: () -> AnyView
    let isPresenting: Binding<Bool>
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
    typealias DismissCallback = () -> Void
    let content: (_ dismiss: @escaping DismissCallback) -> PortalContent
    
    func portal() -> PortalPreference {
        PortalPreference (
            content: {AnyView(self.content({ self.isPresented = false}))},
            isPresenting: $isPresented,
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
    func portal<Content:View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping (_ dismiss:  @escaping () -> Void) -> Content) -> some View {
        modifier(PortalModifier(isPresented: isPresented, content: content))
    }
}
