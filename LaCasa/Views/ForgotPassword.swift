//
//  ForgotPassword.swift
//  LaCasa
//
//  Created by Home Account on 7/24/23.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showForgotPasswordSheet: Bool
    @State private var kerb = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                }.toolbar {
                    ToolbarItemGroup() {
                        Button("Cancel",
                               action: { showForgotPasswordSheet.toggle() })
                    }
                }
            }
            .navigationTitle("Forgot Password")
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(showForgotPasswordSheet: .constant(false))
    }
}
