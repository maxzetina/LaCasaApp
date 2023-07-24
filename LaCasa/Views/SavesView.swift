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
                            Text("\(savesDate.formatted(.dateTime.day().month().weekday()))").font(.title3).foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "calendar").overlay(
                                DatePicker(
                                    "",
                                    selection: $savesDate,
                                    displayedComponents: [.date]
                                ).padding().labelsHidden().blendMode(.destinationOver).onChange(of: savesDate){ newDate in
                                    modelData.getSaves(date: newDate)
                                }
                            )
                        }
                    }
                    
                    ForEach(modelData.saves) { save in
                        SavesRow(save: save).deleteDisabled(save.kerb != "TestApp3")//current signed in kerb
                    }.onDelete(perform: deleteSave)
                
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
                                RequestSave(showRequstSaveSheet: $showRequestSaveSheet)
                            }
                        }
                    }
        }.onAppear{
            modelData.getSaves(date: savesDate)
        }
    }
}

func deleteSave(at offsets: IndexSet) {
    for index in offsets{
        print(index)
    }

//    let _ = print(offsets)
}

struct SavesView_Previews: PreviewProvider {
    static var previews: some View {
        SavesView().environmentObject(ModelData())
    }
}
