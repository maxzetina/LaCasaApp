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
    
//    var a = Data("lacasa2".utf8)

    var body: some View {
        //saves list for the day
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
                                ).padding().labelsHidden().blendMode(.destinationOver)
                            )
                        }
                    }
                    
                    ForEach(modelData.saves) { save in
                        SavesRow(save: save).deleteDisabled(save.name == "TestApp3")//current signed in kerb
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
                                })
                            }
                            
                            Button(action: {
                                showRequestSaveSheet.toggle()
                            }, label: { Image(systemName: "plus") }).sheet(isPresented: $showRequestSaveSheet){
                                RequestSave(showRequstSaveSheet: $showRequestSaveSheet)
                            }
                        }
                    }

//            let _ = print(SHA512.hash(data: a).compactMap { String(format: "%02x", $0) }.joined())
//
        }.onAppear{
            modelData.getSaves()
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
