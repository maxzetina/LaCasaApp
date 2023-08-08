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
                    
                    if(modelData.user.resident == 1){
                        HStack{
                            Text("Position:").fontWeight(.bold)
                            Text(residentInfo.office == "" ? "Resident" : residentInfo.office)
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
                            Spacer()
                        }.padding(.leading).padding(.bottom, 4.0)
                        HStack{
                            if(modelData.user.dietary_restriction != ""){
                                Text("\(modelData.user.dietary_restriction)")
                            }
                            else{
                                Text("None")
                            }
                            Spacer()
                        }.padding([.bottom, .leading])
                    }
                    
                    if(modelData.user.resident == 1){
                        VStack{
                            HStack{
                                Text("GBM Attendance").fontWeight(.bold)
                                Spacer()
                            }.padding()
                            
                            HStack{
                                ForEach([residentInfo.status1, residentInfo.status2, residentInfo.status3, residentInfo.status4], id: \.self){ status in
                                    if(status == "present"){
                                        Image(systemName: "checkmark.circle.fill").resizable().foregroundColor(.green).frame(width: 65)
                                    }
                                    else if(status == "late"){
                                        Image(systemName: "exclamationmark.circle.fill").resizable().scaledToFit().foregroundColor(.yellow).frame(width: 65)
                                    }
                                    else if(status == "absent"){
                                        Image(systemName: "x.circle.fill").resizable().foregroundColor(Color("LoginButtonColor")).frame(width: 65)
                                    }
                                    else{
                                        Circle().fill(.gray).opacity(0.4).frame(width: 65)
                                    }
                                }
                                Spacer()
                            }.padding(.leading)
                        }
                    }
                    //if on exec
                    if(residentInfo.office != ""){
                        VStack{
                            HStack{
                                Text("EBM Attendance").fontWeight(.bold)
                                Spacer()
                            }.padding()
                            
                            
                            HStack{
                                Image(systemName: "checkmark.circle.fill").resizable().foregroundColor(.green).frame(width: 65)
                                //                Image(systemName: "x.circle.fill").resizable().foregroundColor(Color("LoginButtonColor")).frame(width: 65)
                                //                Image(systemName: "exclamationmark.circle.fill").resizable().scaledToFit().foregroundColor(.yellow).frame(width: 65)
                                Circle().fill(.gray).opacity(0.4).frame(width: 65)
                                Circle().fill(.gray).opacity(0.4).frame(width: 65)
                                Circle().fill(.gray).opacity(0.4).frame(width: 65)
                                
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
                //if resident
                if(modelData.user.resident == 1){
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
