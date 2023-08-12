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
        VStack {
            if(!modelData.isLoggedIn){
                Login()
            }
            else{
                TabView() {
                    ChoresView()
                        .tabItem {
                            Label("Chores", systemImage: "list.bullet")
                        }
                    
                    SavesView()
                        .tabItem {
                            Label("Saves", systemImage: "fork.knife")
                        }
                    
                    AccountView()
                        .tabItem{
                            Label("Profile", systemImage: "person")
                        }
                }.onAppear{
                    Task{
                        await modelData.getUser(kerb: modelData.kerb)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
