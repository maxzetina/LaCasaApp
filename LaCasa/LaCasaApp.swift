//
//  LaCasaApp.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/20/23.
//

import SwiftUI

@main
struct LaCasaApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
