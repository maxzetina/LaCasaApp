//
//  ContentView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        TabView() {
            ChoresView()
                .tabItem {
                    Label("Chores", systemImage: "list.bullet")
                }
            
            SavesView()
                .tabItem {
                    Label("Saves", systemImage: "fork.knife")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
