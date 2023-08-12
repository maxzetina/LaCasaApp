//
//  EditProfileView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 8/10/23.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var fname: String = ""
    @State var lname: String = ""
    @State var year: String = ""
    @State var major: String = ""
    @State var dietary_restriction: String = ""
    
    @State var submitPressed: Bool = false
    @State var showAlert: Bool = false
    
    @State var validFname: Bool = false
    @State var validLname: Bool = false
    @State var validYear: Bool = false
    
    func initializeValues() {
        fname = modelData.user.fname
        lname = modelData.user.lname
        year = String(modelData.user.year)
        major = modelData.user.major
        dietary_restriction = modelData.user.dietary_restriction
    }

    var body: some View {
        VStack{
            Form{
                VStack(alignment: .leading) {
                    Text("First Name")
                        .font(.callout)
                        .bold()
                    InputTextField(placeholderText: "First Name", input: $fname)
                }
                
                VStack(alignment: .leading) {
                    Text("Last Name")
                        .font(.callout)
                        .bold()
                    InputTextField(placeholderText: "Last Name", input: $lname)
                }
                
                HStack{
                    VStack(alignment: .leading) {
                        Text("Year")
                            .font(.callout)
                            .bold()
                        InputTextField(placeholderText: "Year", width: 125, input: $year).keyboardType(.numberPad).onChange(of: year){ newYear in
                            if newYear.count > 4 {
                                year = String(newYear.prefix(4))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Major")
                            .font(.callout)
                            .bold()
                        InputTextField(placeholderText: "Major", width: 125, input: $major)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Dietary Restriction")
                        .font(.callout)
                        .bold()
                    InputTextField(placeholderText: "Dietary Restriction", input: $dietary_restriction)
                }
                
                Button(action: {
                    Task{
                        validFname = checkName(text: fname)
                        validLname = checkName(text: lname)
                        validYear = checkYear(text: year)
                        
                        if(!(validFname && validLname && validYear)){
                            showAlert.toggle()
                        }
                        else{
                            submitPressed.toggle()

                            _ = await modelData.updateProfile(fname: fname, lname: lname, year: Int(year) ?? 0, major: major, dietary_restriction: dietary_restriction)
                            
                            _ = await modelData.getUser(kerb: modelData.user.kerb)
                            
                            submitPressed.toggle()
                        }
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.blue).overlay(
                        
                        VStack{
                            if(submitPressed){
                                LoadingSpinner(scale: 1.5, tint: .white)
                            }
                            else{
                                Text("Save").foregroundColor(.white).fontWeight(.bold).font(.title3)
                            }
                        }
                    )
                }).padding().listRowBackground(Color.clear).alert(isPresented: $showAlert){
                    var title = ""
                    var msg = ""
                    if(!validFname){
                        title = "Invalid First Name"
                        msg = "First name must not be empty or have special characters, numbers, or surrounding whitespaces"
                    }
                    else if(!validLname){
                        title = "Invalid Last Name"
                        msg = "Last name must not be empty or have special characters, numbers, or surrounding whitespaces"
                    }
                    else if(!validYear){
                        title = "Invalid Class Year"
                        msg = "Class year must be in the form 20XX"
                    }
                    
                    return Alert(
                        title: Text(title),
                        message: Text(msg)
                    )
                }
            }
        }.navigationTitle("Edit Profile").onAppear(perform: initializeValues)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView().environmentObject(ModelData())
    }
}
