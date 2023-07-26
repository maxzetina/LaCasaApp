//
//  SignUp.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/20/23.
//

import SwiftUI

struct SignUp: View {
    @Binding var showSignupSheet: Bool
    
    @EnvironmentObject var modelData: ModelData
    
    @State private var kerb = ""
    @State private var password = ""
    @State private var confirmedPassword = ""

    @State var passwordVisible: Bool = false
    @State var showAlert: Bool = false
    
    @State var kerbMeetsLen: Bool = false
    @State var passwordsMatch: Bool = false
    
    @State var pwMeetsLen: Bool = false
    @State var includesUppercase: Bool = false
    @State var includesNumber: Bool = false
    @State var includesSymbol: Bool = false
    
    @State var signUpPressed: Bool = false
    
    @FocusState var isKerbInputActive: Bool
    @FocusState var isPwInputActive: Bool
    @FocusState var isConfirmPwInputActive: Bool

    
    let bulletPoint: String = "\u{2022}"
    let minPasswordLen = 8
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                Spacer().frame(height: 150)
                VStack(alignment: .leading){
                    KerbTextField(kerb: $kerb).focused($isKerbInputActive)
                    
                    Spacer().frame(height: 25)
                    
                    Group{
                        Text("Your password must:").fontWeight(.bold).padding(.bottom, 4.0)
                        
                        Text(bulletPoint + "  Be at least \(minPasswordLen) characters").foregroundColor(pwMeetsLen ? .green : .red)
                        Text(bulletPoint + "  Include an uppercase letter").foregroundColor(includesUppercase ? .green : .red)
                        Text(bulletPoint + "  Include at least one number").foregroundColor(includesNumber ? .green : .red)
                        Text(bulletPoint + "  Include at least one symbol").foregroundColor(includesSymbol ? .green : .red)
                    }
                    
                    PasswordTextField(password: $password).onChange(of: password){ newValue in
                        
                        pwMeetsLen = newValue.count >= minPasswordLen
                        includesUppercase = containsUppercase(text: newValue)
                        includesNumber = containsNumber(text: newValue)
                        includesSymbol = containsSymbol(text: newValue)
                        
                        passwordsMatch = confirmedPassword == newValue
                    }.toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                if isKerbInputActive {
                                    isKerbInputActive = false
                                }
                                if isPwInputActive {
                                   isPwInputActive = false
                                    isConfirmPwInputActive = true
                               } else {
                                   isConfirmPwInputActive = false
                               }
                            }
                        }
                    }
                    .focused($isPwInputActive)
                    
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
                        HStack{
                            SecureField("Confirm password", text: $confirmedPassword)   .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding(.leading, 12.0)
                                .onChange(of: confirmedPassword){
                                    newValue in
                                    
                                    passwordsMatch = password == newValue
                                }
                        }
                    ).padding(.bottom, 4.0).focused($isConfirmPwInputActive)
                    
                    
                    Text("Passwords must match").foregroundColor(passwordsMatch ? .green : .red).font(.footnote)
                    
                    Spacer().frame(height: 60)
                    
                    Button(action: {
                        Task {
                            kerbMeetsLen = 3 <= kerb.count && kerb.count <= 8
                            
                            if(!(kerbMeetsLen && pwMeetsLen && includesUppercase && includesNumber && includesSymbol && passwordsMatch)){
                                showAlert.toggle()
                            }
                            else{
                                signUpPressed.toggle()
                                
                                //need route for new person signup and resident signup - only edit password column if resident checkbox
//                                await modelData.signup(fname: String, lname: <#T##String#>, kerb: kerb, year: <#T##Int#>, major: <#T##String#>, password: password, resident: <#T##Int#>)
                                showSignupSheet.toggle()
                                signUpPressed.toggle()
                            }
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(Color("LoginButtonColor")).overlay(
                            
                            VStack{
                                if(signUpPressed){
                                    ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                else{
                                    Text("Sign Up").foregroundColor(.white).fontWeight(.bold).font(.title3)
                                }
                            }
                        )
                    }).alert(isPresented: $showAlert){
                        var title = ""
                        var msg = ""
                        if(!kerbMeetsLen) {
                            title = "Invalid Kerb"
                            msg = "Kerb must be between 3 and 8 characters"
                        }
                        else if(!pwMeetsLen || !includesUppercase || !includesNumber || !includesSymbol){
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
                .toolbar {
                    ToolbarItemGroup() {
                        Button("Cancel",
                               action: { showSignupSheet.toggle() })
                    }
                }
            }.navigationTitle("Create Account")
        }
    }
}

func containsUppercase(text: String) -> Bool {
    guard let uppercaseRegex = try? Regex("[A-Z]+") else { return false }
    return text.contains(uppercaseRegex)
}

func containsNumber(text: String) -> Bool {
    guard let digitRegex = try? Regex("[0-9]+") else { return false }
    return text.contains(digitRegex)
}

func containsSymbol(text: String) -> Bool {
    guard let symbolRegex = try? Regex("[^A-Za-z0-9]") else { return false }
    return text.contains(symbolRegex)
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(showSignupSheet: .constant(true)).environmentObject(ModelData())
    }
}
