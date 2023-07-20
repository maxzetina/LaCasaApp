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
    @State var passwordVisible: Bool = false
    
    @State var showSignupSheet: Bool = false
    

    var body: some View {
        VStack{
            Image("LSImageA")
            
            RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
                HStack{
                    Image(systemName: "person.fill").padding(.leading)
                    
                    TextField("kerb", text: $kerb)   .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading, 4.0)
                }
            ).padding(.bottom, 4.0)
            
            RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
                HStack{
                    Image(systemName: "lock.fill").padding(.leading)
                    
                    if(passwordVisible){
                        TextField("password", text: $password)   .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding(.leading, 4.0)
                    }
                    else{
                        SecureField("password", text: $password)   .disableAutocorrection(true)
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
        
           
            Button("Forgot Password"){
                
            }.foregroundColor(Color("ForgotPwColor"))
            
            
            Spacer().frame(height: 60)
            Button(action: {
                Task{
                    loginPressed.toggle()
                    
                    isLoggedIn = await modelData.handleLogin(kerb: kerb, password: password)
                    if(isLoggedIn){
                        user = kerb
                    }
                    else{
                        loginPressed.toggle()
                    }
                }
            }, label: {
                RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(Color("LoginButtonColor")).overlay(
                    
                    VStack{
                        if(loginPressed){
                            ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .white))
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
        Login(isLoggedIn: .constant(true), user: .constant("")).environmentObject(ModelData())
    }
}

