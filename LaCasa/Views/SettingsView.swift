//
//  SettingsView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 8/7/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var modelData: ModelData

    @State var deletingAccount: Bool = false
    @State var deleteAccountAlert: Bool = false
    
    var body: some View {
        VStack{
            List{
                Section("Profile"){
                    NavigationLink{
                        EditProfileView()
                    } label: {
                        Text("Edit Profile")
                    }
                    
                    NavigationLink{
                        ChangePasswordView()
                    } label: {
                        Text("Change Password")
                    }
                }
                
                Section("Account"){
                    Button(action:
                    {
                        deleteAccountAlert.toggle()
                        
                    }, label: { Text("Delete Account").foregroundColor(.red) })
                    .alert(isPresented: $deleteAccountAlert){
                        Alert(title: Text("Delete Account?"),
                              message: Text("This will remove you from La Casa's system and cannot be undone"),
                              primaryButton: .cancel(Text("Cancel")),
                              secondaryButton: .destructive(Text("Delete"))
                              {
                                Task{
                                    deletingAccount = true
                                    
                                    _ = await modelData.deleteAccount()
                                    
                                    deletingAccount = false
                                    modelData.isLoggedIn = false
                                    modelData.kerb = ""
                                    modelData.resetUser()
                                    
                                }
                            }
                        )
                    }
                }
                
                if(deletingAccount){
                    HStack{
                        Spacer()
                        LoadingSpinner(scale: 2.0, tint: .blue)
                        Spacer()
                        
                    }.listRowBackground(Color.clear)
                }
            }
        }.navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ModelData())
    }
}
