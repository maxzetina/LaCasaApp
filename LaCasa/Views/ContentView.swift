//
//  ContentView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("kerb") var kerb: String = ""

    var body: some View {
        VStack {
            if(!isLoggedIn){
                Login(isLoggedIn: $isLoggedIn, user: $kerb)
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
                    
                    AccountView(isLoggedIn: $isLoggedIn, kerb: $kerb)
                        .tabItem{
                            Label("Profile", systemImage: "house")
                    }
                }
            }
        }.onAppear{
            Task{
                await modelData.getUser(kerb: kerb)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
