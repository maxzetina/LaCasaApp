//
//  PasswordTextField.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/20/23.
//

import SwiftUI

struct PasswordTextField: View {
    var placeholder: String
    @Binding var password: String
    
    @State var passwordVisible: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
            HStack{
                Image(systemName: "lock.fill").padding(.leading)
                
                if(passwordVisible){
                    TextField("", text: $password)   .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading, 4.0)
                }
                else{
                    SecureField(placeholder, text: $password)   .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading, 4.0)
                }
                
                Button(action: {
                    passwordVisible.toggle()
                }, label: {
                    Image(systemName: passwordVisible ? "eye.slash.fill" : "eye.fill").foregroundColor(.gray)
                    
                }).padding(.trailing)
            }
        ).padding(.bottom, 4.0)
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(placeholder: "password", password: .constant("password"), passwordVisible: false)
    }
}
