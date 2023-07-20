//
//  SignUp.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/20/23.
//

import SwiftUI

struct SignUp: View {
    @Binding var showSignupSheet: Bool
    
    @State private var kerb = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                TextField("kerb", text: $kerb)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                
                TextField("password", text: $password)
            }
                .navigationTitle("Create Account").font(.title).toolbar {
                ToolbarItemGroup() {
                    Button("Cancel",
                           action: { showSignupSheet.toggle() })
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(showSignupSheet: .constant(true))
    }
}
