//
//  ForgotPassword.swift
//  LaCasa
//
//  Created by Marvin Zetina-Jimenez on 7/24/23.
//

import SwiftUI

struct ForgotPassword: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var showForgotPasswordSheet: Bool
    
    @State var sendPressed = false
    @State var showKerbField = false
    @State var showAlert: Bool = false
    @FocusState var isKerbInputActive: Bool
    
    @State private var kerb = ""
    @State private var sendButtonText = "SEND"
    @State private var sendButtonColor: Color = Color("LoginButtonColor")
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Section{
                        Spacer()
                        
                        Text("Click the button below to send a temporary password to your kerb (without the @). Use it to login then change your password after logging in.").padding(.bottom, 8.0)
                            .frame(width: 300)
                    }
                    
                    Spacer()
                    
                    InputTextField(placeholderText: "kerb", input: $kerb, img: Image(systemName: "person.fill")).focused($isKerbInputActive).toolbar{
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                if isKerbInputActive {
                                    isKerbInputActive = false
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        Task{
                            if !checkKerb(text: kerb){
                                showAlert.toggle()
                            } else {
                                sendPressed.toggle()
                                
                                
                                let isSent = await modelData.requestPassword(kerb: kerb)
                                
                                if(isSent){
                                    sendButtonText = "SUCCESS!"
                                    sendButtonColor = Color(.green)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                                    {
                                        sendPressed.toggle()
                                        showForgotPasswordSheet.toggle()
                                    }
                                }
                                else{
                                    showAlert.toggle()
                                    sendPressed.toggle()
                                }
                            }
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(sendButtonColor).shadow(radius: 10).overlay(
                            Text(sendButtonText).foregroundColor(.white).fontWeight(.bold).font(.title3)
                        )
                    }).alert(isPresented: $showAlert){
                        return Alert(
                            title: Text("Invalid Kerb"),
                            message: Text("Please fix the kerb and try again")
                        )
                    }
                }.toolbar {
                    ToolbarItemGroup() {
                        Button("Done") { showForgotPasswordSheet.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Forgot Password")
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword(showForgotPasswordSheet: .constant(false)).environmentObject(ModelData())
    }
}
