//
//  Saves.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI
import CryptoKit

struct SavesView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var savesDate = Date()
    @State var dinnerPushedAlert: Bool = false
    @State var showRequestSaveSheet: Bool = false
    
    var body: some View {
        NavigationView{
                List{
                    Section{
                        HStack{
                            Text("On:").fontWeight(.semibold)
                            Spacer()
                            
                            Text("\(savesDate.formatted(.dateTime.day().month().weekday()))").font(.title3).foregroundColor(.red).fontWeight(Calendar.current.isDate(savesDate, inSameDayAs: Date()) ? .bold : .none)
                            
                            Spacer()
                            
                            Image(systemName: "calendar").overlay(
                                DatePicker(
                                    "",
                                    selection: $savesDate,
                                    displayedComponents: [.date]
                                ).padding().tint(.red).labelsHidden().blendMode(.destinationOver).onChange(of: savesDate){ newDate in
                                    modelData.getSaves(date: newDate)
                                }
                            )
                        }
                    }
                    
                    if(!modelData.saves.isEmpty){
                        ForEach(modelData.saves) { save in
                            SavesRow(save: save).swipeActions{
                                Button(role: .destructive) {
                                    Task {
                                        await modelData.deleteSave(saveId: save.id)
                                        
                                        modelData.getSaves(date: savesDate)
                                    }
                                 } label: {
                                     Label("Delete", systemImage: "trash.fill")
                                 }.disabled(save.kerb != modelData.user.kerb)
                            }
                        }
                    }
                    else {
                        HStack{
                            Spacer()
                            Text("There are no saves!").font(.title2)
                            Spacer()
                        }.listRowBackground(Color.clear)
                    }
                
                }.navigationTitle("Saves")
                .toolbar{
                    ToolbarItemGroup() {
                            Button(action:
                            {
                                dinnerPushedAlert.toggle()
                                
                            }, label: { Image(systemName: "clock") })
                            .alert(isPresented: $dinnerPushedAlert){
                                Alert(title: Text("Push Dinner?"),
                                      message: Text("This will send a message in slack and an email"),
                                      primaryButton: .destructive(Text("Cancel")),
                                      secondaryButton: .default(Text("Yes"))
                                      {
                                          Task {
                                              await modelData.pushDinner()
                                           }
                                       }
                                )
                            }
                            
                            Button(action: {
                                showRequestSaveSheet.toggle()
                            }, label: { Image(systemName: "plus") }).sheet(isPresented: $showRequestSaveSheet){
                                RequestSave(showRequestSaveSheet: $showRequestSaveSheet, savesDate: savesDate)
                            }
                        }
                }.refreshable {
                    savesDate = Date()
                    modelData.getSaves(date: savesDate)
                }
        }.navigationViewStyle(StackNavigationViewStyle()).onAppear{
            modelData.getSaves(date: savesDate)
        }
    }
}

struct SavesView_Previews: PreviewProvider {
    static var previews: some View {
        SavesView().environmentObject(ModelData())
    }
}
