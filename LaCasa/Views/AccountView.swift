//
//  Home.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var modelData: ModelData

    @State var residentInfo: ResidentInfo = ResidentInfo.default
    @State var logoutAlert: Bool = false
    
    @State var editDietaryRestriction: Bool = false
    @State var newRestriction: String = ""
    @FocusState var editRestrictionFocused
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollView{
                    HStack{
                        Text("\(modelData.user.fname) \(modelData.user.lname)")
                            .font(.title).fontWeight(.bold)
                    }.padding()
                    
                    HStack{
                        HStack{
                            Spacer()
                            Text("\(String(modelData.user.year))")
                            Spacer()
                        }
                        
                        Text("|")
                        
                        HStack{
                            Spacer()
                            Text("\(modelData.user.kerb)")
                            Spacer()
                        }
                        
                        Text("|")
                        
                        HStack{
                            Spacer()
                            Text("\(modelData.user.major)")
                            Spacer()
                        }
                    }.font(.title3).fontWeight(.thin)
                    
                    
                    Divider().padding()
                    
                    if(modelData.user.isResident()){
                        HStack{
                            Text("Position:").fontWeight(.bold)
                            Text(residentInfo.isExec() ? residentInfo.office : "Resident")
                            Spacer()
                            Text("Room:").fontWeight(.bold)
                            Text(String(residentInfo.room))
                        }.padding()
                        
                        HStack{
                            Text("Housing Pts:").fontWeight(.bold)
                            Text(String(residentInfo.total_housing_points))
                            Spacer()
                        }.padding([.bottom, .leading])
                    }
                    
                    VStack{
                        HStack{
                            Text("Dietary Restriction").fontWeight(.bold)
                            Button(action: {
                                editDietaryRestriction = true
                                editRestrictionFocused = true
                            }, label: {
                                Image(systemName: "pencil").padding(.trailing)
                            })
                            Spacer()
                        }.padding(.leading).padding(.bottom, 4.0)
                        
                        HStack{
                            if(editDietaryRestriction){
                                TextField("", text: $newRestriction).focused($editRestrictionFocused).disableAutocorrection(true).onSubmit {
                                    editRestrictionFocused = false
                                    editDietaryRestriction = false
                                    newRestriction = modelData.user.dietary_restriction
                                }.toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Button("Cancel", role: .cancel){
                                            editRestrictionFocused = false
                                            editDietaryRestriction = false
                                            newRestriction = modelData.user.dietary_restriction
                                        }
                                        
                                        Spacer()

                                        Button("Update"){
                                            Task{
                                                _ = await modelData.updateDietaryRestriction(restriction: newRestriction)
                                                modelData.user.dietary_restriction = newRestriction
                                                editRestrictionFocused = false
                                                editDietaryRestriction = false
                                            }
                                        }
                                    }
                                }
                            }
                            else{
                                Text(modelData.user.dietary_restriction == "" ? "None" : modelData.user.dietary_restriction)
                            }
                            Spacer()
                        }.padding([.bottom, .leading])
                    }
                    
                    if(modelData.user.isResident()){
                        VStack{
                            HStack{
                                Text("GBM Attendance").fontWeight(.bold)
                                Spacer()
                            }.padding()
                            
                            HStack{
                                ForEach(residentInfo.gbm_attendance, id: \.self){ status in
                                    AttendanceCircle(status: status)
                                }
                                Spacer()
                            }.padding(.leading)
                        }
                    }

                    if(residentInfo.isExec()){
                        VStack{
                            HStack{
                                Text("EBM Attendance").fontWeight(.bold)
                                Spacer()
                            }.padding()
                            
                            HStack{
                                ForEach(residentInfo.ebm_attendance, id: \.self){ status in
                                    AttendanceCircle(status: status)
                                }
                                Spacer()
                            }.padding(.leading)
                        }.padding(.bottom)
                    }
                }
            }.toolbar{
                ToolbarItemGroup(placement: .navigation) {
                    NavigationLink{
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItemGroup(){
                    Button(action:
                    {
                        logoutAlert.toggle()
                        
                    }, label: { Image(systemName: "rectangle.portrait.and.arrow.right") })
                    .alert(isPresented: $logoutAlert){
                        Alert(title: Text("Logout?"),
                              message: Text(""),
                              primaryButton: .destructive(Text("Cancel")),
                              secondaryButton: .default(Text("Logout"))
                               {
                                    modelData.isLoggedIn = false
                                    modelData.kerb = ""
                                    modelData.resetUser()
                               }
                        )
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()).onAppear{
            Task{
                newRestriction = modelData.user.dietary_restriction
                
                if(modelData.user.isResident()){
                    residentInfo = await modelData.getResidentInfo()
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView().environmentObject(ModelData())
    }
}
