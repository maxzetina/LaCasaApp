//
//  Home.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct Home: View {
    @Binding var isLoggedIn: Bool
    @Binding var kerb: String
    
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack{
            Text("Welcome \(modelData.user.kerb)")
                .font(.title)
            
            
            Button("Logout"){
                isLoggedIn = false
                kerb = ""
                modelData.resetUser()
            }
        }.onAppear{
            Task{
                await modelData.getUser(kerb: kerb)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(isLoggedIn: .constant(true), kerb: .constant("KERB")).environmentObject(ModelData())
    }
}
