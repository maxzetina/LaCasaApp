//
//  Home.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import SwiftUI

struct AccountView: View {
    @Binding var isLoggedIn: Bool
    @Binding var kerb: String
    
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        ScrollView{
            Spacer().frame(height: 50)
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
            
            HStack{
                Text("Position:").fontWeight(.bold)
                Text("Webmaster")
                Spacer()
                Text("Room:").fontWeight(.bold)
                Text("4218")
            }.padding()
            
            HStack{
                Text("Housing Pts:").fontWeight(.bold)
                Text("12")
                Spacer()
            }.padding([.bottom, .leading])

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
            
            VStack{
                HStack{
                    Text("GBM Attendance").fontWeight(.bold)
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
            }
            
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
            
//            Divider().padding()
                        
            
            
//            Button("Logout"){
//                isLoggedIn = false
//                kerb = ""
//                modelData.resetUser()
//            }
        }.onAppear{
            Task{
                await modelData.getUser(kerb: kerb)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isLoggedIn: .constant(true), kerb: .constant("zetina")).environmentObject(ModelData())
    }
}
