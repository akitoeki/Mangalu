//
//  AppSettings.swift
//  Manhwalu
//
//  Created by Nhan Dang on 10/1/20.
//  Copyright © 2020 Nhan Dang. All rights reserved.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var nsfw: Bool = UserDefaults.standard.bool(forKey: "nsfw")    
}
