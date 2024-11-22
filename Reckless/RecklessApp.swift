//
//  RecklessApp.swift
//  Reckless
//
//  Created by Facundo Kzemin on 11/07/2024.
//

import SwiftUI
import MapboxMaps

@main
struct RecklessApp: App {
    @ObservedObject var navigation = Navigation()
    
    var body: some Scene {
        WindowGroup {
            ContentView(navigation: navigation)
        }
    }
}
