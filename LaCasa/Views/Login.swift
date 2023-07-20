//
//  Login.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct Login: View {
    @Binding var isLoggedIn: Bool
    @Binding var user: String

    @EnvironmentObject var modelData: ModelData

    @State private var kerb = ""
    @State private var password = ""
    @State var loginPressed: Bool = false
    

    var body: some View {
        VStack{
            Image("LSImageA")
            
            TextField("kerb", text: $kerb)   .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            
            SecureField("password", text: $password)   .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
            if(loginPressed){
                ProgressView()
            }
            else{
                Button("Login"){
                    Task{
                        isLoggedIn = await modelData.handleLogin(kerb: kerb, password: password)
                        if(isLoggedIn){
                            user = kerb
                        }
                    }
                }
            }

            Spacer()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(isLoggedIn: .constant(true), user: .constant("")).environmentObject(ModelData())
    }
}

