//
//  Login.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var modelData: ModelData

    @State private var kerb = ""
    @State private var password = ""
    @State var loginPressed: Bool = false
    @State var passwordVisible: Bool = false
    
    @State var showSignupSheet: Bool = false
    @State var showForgotPasswordSheet: Bool = false
    
    @FocusState var isKerbInputActive: Bool
    @FocusState var isPwInputActive: Bool


    var body: some View {
        VStack{
            Image("LSImageA")
            
            InputTextField(placeholderText: "kerb", input: $kerb, img: Image(systemName: "person.fill")).toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        if isKerbInputActive {
                           isKerbInputActive = false
                            isPwInputActive = true
                       } else {
                           isPwInputActive = false
                       }
                    }
                }
            }
            .focused($isKerbInputActive)

            
            PasswordTextField(placeholder: "password", password: $password)
            .focused($isPwInputActive)
        
           
            Button("Forgot Password?"){
                showForgotPasswordSheet.toggle()
            }.foregroundColor(Color("ForgotPwColor")).sheet(isPresented: $showForgotPasswordSheet){
                
                ForgotPassword(showForgotPasswordSheet: $showForgotPasswordSheet)
            }
            
            
            Spacer().frame(height: 60)
            Button(action: {
                Task{
                    loginPressed.toggle()
                    
                    let res = await modelData.handleLogin(kerb: kerb, password: password)
                    
                    modelData.isLoggedIn = res.result
                    
                    if(modelData.isLoggedIn){
                        modelData.kerb = kerb
                    }
                    else{
                        loginPressed.toggle()
                    }
                }
            }, label: {
                RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(Color("LoginButtonColor")).shadow(radius: 10).overlay(
                    
                    VStack{
                        if(loginPressed){
                            LoadingSpinner(scale: 1.5, tint: .white)
                        }
                        else{
                            Text("LOGIN").foregroundColor(.white).fontWeight(.bold).font(.title3)
                        }
                    }
                )
            })
            
            Spacer().frame(height: 25)

            Button("Sign Up"){
                showSignupSheet.toggle()
            }.foregroundColor(.black).sheet(isPresented: $showSignupSheet){
                
                SignUp(showSignupSheet: $showSignupSheet)
            }
                
            Spacer()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().environmentObject(ModelData())
    }
}

