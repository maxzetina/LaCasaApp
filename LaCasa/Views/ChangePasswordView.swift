//
//  ChangePasswordView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 8/9/23.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var modelData: ModelData

    @State var correctPassword: Bool = false
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmNewPassword: String = ""
    
    @State var pwMeetsLen: Bool = false
    @State var includesUppercase: Bool = false
    @State var includesNumber: Bool = false
    @State var includesSymbol: Bool = false
    
    @State var passwordsMatch: Bool = false
    
    @State var submitPressed: Bool = false
    
    @State var showAlert: Bool = false
    
    let bulletPoint: String = "\u{2022}"
    let minPasswordLen = 8
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack{
            List{
                PasswordTextField(placeholder: "Current Password", password: $currentPassword).listRowSeparator(.hidden)
                VStack(alignment: .leading){
                    Text("Your password must:").fontWeight(.bold).padding(.bottom, 4.0)
                    
                    Text(bulletPoint + "  Be at least \(minPasswordLen) characters").foregroundColor(pwMeetsLen ? .green : .red)
                    Text(bulletPoint + "  Include an uppercase letter").foregroundColor(includesUppercase ? .green : .red)
                    Text(bulletPoint + "  Include at least one number").foregroundColor(includesNumber ? .green : .red)
                    Text(bulletPoint + "  Include at least one symbol").foregroundColor(includesSymbol ? .green : .red)
                }
                PasswordTextField(placeholder: "New Password", password: $newPassword).listRowSeparator(.hidden).onChange(of: newPassword){ newValue in
                    
                    pwMeetsLen = newValue.count >= minPasswordLen
                    includesUppercase = containsUppercase(text: newValue)
                    includesNumber = containsNumber(text: newValue)
                    includesSymbol = containsSymbol(text: newValue)
                    
                    passwordsMatch = confirmNewPassword == newValue
                    
                    let _ = print(passwordsMatch)
                }
                PasswordTextField(placeholder: "Confirm New Password", password: $confirmNewPassword).listRowSeparator(.hidden).onChange(of: confirmNewPassword){
                        newValue in
                        passwordsMatch = currentPassword == newValue
                    }
                
                Button(action: {
                    Task{
                        let encryptedInput = modelData.encryptString(text: currentPassword)
                        correctPassword = modelData.user.password == encryptedInput

                        if(correctPassword && pwMeetsLen && includesUppercase && includesNumber && includesSymbol && passwordsMatch){
                            submitPressed.toggle()
                            let res = await modelData.changePassword(newPassword: newPassword)
                            if(res.result){
                                modelData.user.password = encryptedInput
                            }
                            submitPressed.toggle()
                            dismiss()
                        }
                        else{
                            showAlert.toggle()
                        }
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.blue).overlay(
                        
                        VStack{
                            if(submitPressed){
                                LoadingSpinner(scale: 1.5, tint: .white)
                            }
                            else{
                                Text("Change Password").foregroundColor(.white).fontWeight(.bold).font(.title3)
                            }
                        }
                    )
                }).padding().listRowBackground(Color.clear).alert(isPresented: $showAlert){
                    var title = ""
                    var msg = ""
                    if(!correctPassword){
                        title = "Current password does not match"
                    }
                    else if(!(pwMeetsLen && includesUppercase && includesNumber && includesSymbol)){
                        title = "Invalid Password"
                        msg = "Check password requirements"
                    }
                    else{
                        title = "Passwords don't match"
                    }
                    
                    return Alert(
                        title: Text(title),
                        message: Text(msg)
                    )
                }
            }
        }.navigationTitle("Change Password")
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView().environmentObject(ModelData())
    }
}
