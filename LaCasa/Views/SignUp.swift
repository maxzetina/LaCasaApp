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
        
    @State private var residentIndex = 0
    @State private var kerb = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    
    @State private var fname = ""
    @State private var lname = ""
    @State private var year = ""
    @State private var major = ""

    @State var passwordVisible: Bool = false
    @State var showAlert: Bool = false
    
    @State var validKerb: Bool = true
    @State var validFname: Bool = false
    @State var validLname: Bool = false
    @State var validYear: Bool = false
    @State var passwordsMatch: Bool = false
    
    @State var pwMeetsLen: Bool = false
    @State var includesUppercase: Bool = false
    @State var includesNumber: Bool = false
    @State var includesSymbol: Bool = false
    
    @State var signUpPressed: Bool = false
    
    @FocusState var isKerbInputActive: Bool
    @FocusState var isFnameInputActive: Bool
    @FocusState var isLnameInputActive: Bool
    
    @FocusState var isYearInputActive: Bool
    @FocusState var isMajorInputActive: Bool
    
    @FocusState var isPwInputActive: Bool
    @FocusState var isConfirmPwInputActive: Bool

    
    let bulletPoint: String = "\u{2022}"
    let minPasswordLen = 8
    
    enum Role: String, CaseIterable, Identifiable {
        case resident, nonresident
        var id: Self { self }
    }
    @State private var selectedRole: Role = .nonresident

    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                Spacer().frame(height: 10)

                VStack(alignment: .leading){
                    VStack {
                        Picker("Role", selection: $selectedRole) {
                            ForEach(Role.allCases) { role in
                                Text(role.rawValue.capitalized)
                            }
                        }.padding([.top, .bottom])
                    }
                    .pickerStyle(.segmented).frame(width: 300)

                    if(selectedRole == Role.resident){
                        Picker("Kerb", selection: $residentIndex){
                            ForEach(Array(modelData.residents.enumerated()), id: \.offset) { offset, resident in
                                Text(resident.kerb).tag(offset)
                            }
                        }.frame(width: 300).pickerStyle(.wheel)
                    }
                    else{
                        InputTextField(placeholderText: "kerb", input: $kerb, img: Image(systemName: "person.fill")).focused($isKerbInputActive)
                        InputTextField(placeholderText: "First name", input: $fname, autocapitalize: true).focused($isFnameInputActive)
                        InputTextField(placeholderText: "Last name", input: $lname, autocapitalize: true).focused($isLnameInputActive)
                        
                        HStack{
                            InputTextField(placeholderText: "Year", width: 125, input: $year, img: Image(systemName: "graduationcap.fill")).keyboardType(.numberPad).focused($isYearInputActive)

                            Spacer()

                            InputTextField(placeholderText: "Course", width: 125, input: $major, img: Image(systemName: "text.book.closed.fill")).focused($isMajorInputActive)
                        }.frame(width: 300)
                        
                        Spacer().frame(height: 25)
                    }

                    Section{
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
                    }.focused($isPwInputActive).toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()

                            Button("Done") {
                                if isKerbInputActive {
                                    isKerbInputActive = false
                                    isFnameInputActive = true
                                }
                                if isFnameInputActive {
                                   isFnameInputActive = false
                                    isLnameInputActive = true
                               } else {
                                   isLnameInputActive = false
                               }
                                
                                if isYearInputActive {
                                    isYearInputActive = false
                                    isMajorInputActive = true
                                }
                                else {
                                    isMajorInputActive = false
                                }
                                
                                if isPwInputActive {
                                    isPwInputActive = false
                                    isConfirmPwInputActive = true
                                }
                                else {
                                    isConfirmPwInputActive = false
                                }
                            }
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
                        HStack{
                            SecureField("Confirm password", text: $confirmedPassword)   .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding(.leading, 12.0)
                                .onChange(of: confirmedPassword){
                                    newValue in
                                    
                                    passwordsMatch = password == newValue
                                }
                                .focused($isConfirmPwInputActive)
                        }
                    ).padding(.bottom, 4.0)
                    
                    
                    Text("Passwords must match").foregroundColor(passwordsMatch ? .green : .red).font(.footnote)
                    
                    Spacer().frame(height: 25)
                    
                    Button(action: {
                        Task {
                            let validPw = pwMeetsLen && includesUppercase && includesNumber && includesSymbol && passwordsMatch
                            
                            if(selectedRole == Role.resident){
                                if(!validPw){
                                    showAlert.toggle()
                                }
                                
                                else{
                                    signUpPressed.toggle()
                                    
                                    let residentKerb = modelData.residents[residentIndex].kerb
                                    await modelData.signupResident(kerb: residentKerb, password: password)
                                    
                                    showSignupSheet.toggle()
                                    signUpPressed.toggle()
                                }
                            }
                            
                            
                            if(selectedRole == Role.nonresident){
                                validKerb = checkKerb(text: kerb)
                                validFname = checkName(text: fname)
                                validLname = checkName(text: lname)
                                validYear = checkYear(text: year)
                                
                                if(!(validKerb && validFname && validLname && validYear && validPw)){
                                    showAlert.toggle()
                                }
                                else{
                                    signUpPressed.toggle()
                                    
                                    await modelData.signupNonresident(fname: fname, lname: lname, kerb: kerb, year: Int(year) ?? 0, major: major, password: password)
                                    
                                    
                                    showSignupSheet.toggle()
                                    signUpPressed.toggle()
                                }
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
                        if(!validKerb) {
                            title = "Invalid Kerb"
                            msg = "Kerb must be 3-8 lowercase, alphanumeric characters (including underscores) and cannot start with a digit."
                        }
                        else if(!validFname){
                            title = "Invalid First Name"
                            msg = "First name must not be empty or have special characters or numbers"
                        }
                        else if(!validLname){
                            title = "Invalid Last Name"
                            msg = "Last name must not be empty or have special characters or numbers"
                        }
                        else if(!validYear){
                            title = "Invalid Class Year"
                            msg = "Class year must be in the form 20XX"
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
        }.onAppear{
            modelData.getResidents()
        }
    }
}

func checkKerb(text: String) -> Bool {
    if(text.isEmpty || text.count > 8 || text.count < 3  ) { return false }

    guard let kerbRegex = try? Regex("[a-z_][a-z0-9_]+") else {return false}
    if let match = text.wholeMatch(of: kerbRegex) {
        let matchedString = match.output[0].substring ?? "not found"
        if matchedString == text {
            return true
        }
    }
    return false
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

func checkName(text: String) -> Bool {
    if(text.isEmpty) { return false }

    guard let nameRegex = try? Regex("^[A-Za-z][A-Za-z'-]*([ A-Za-z][A-Za-z'-]+)*") else { return false }
    if let match = text.wholeMatch(of: nameRegex) {
        let matchedString = match.output[0].substring ?? "not found"
        if matchedString == text {
            return true
        }
    }
    return false
}

func checkYear(text: String) -> Bool {
    guard let yearRegex = try? Regex("[2][0][0-9]{2}$") else { return false }
    return text.contains(yearRegex)
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(showSignupSheet: .constant(true)).environmentObject(ModelData())
    }
}
