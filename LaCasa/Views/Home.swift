//
//  Home.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct Home: View {
    var kerb: String
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack{
            Text(kerb)
            Button("Logout"){
                isLoggedIn = false
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(kerb: "KERB", isLoggedIn: .constant(true))
    }
}
