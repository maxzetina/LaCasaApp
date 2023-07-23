//
//  Home.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct Home: View {
    @Binding var isLoggedIn: Bool
    var kerb: String
    
    @State var welcomeAnimation: Bool = true
    @State var viewAnimation: Bool = true
    
    var body: some View {
        VStack{
            Text("Welcome \(kerb)")
                .font(.title)
            
            
            Button("Logout"){
                isLoggedIn = false
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(isLoggedIn: .constant(true), kerb: "KERB")
    }
}
