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
    @State private var date = Date()
    var a = Data("lacasa2".utf8)

    var body: some View {
        VStack{
            //saves list for the day
            ForEach(modelData.saves, id: \.name) { save in
                Text(save.name)
            }
            
//            let _ = print(SHA512.hash(data: a).compactMap { String(format: "%02x", $0) }.joined())

            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            ).padding()

            //name, day, request - all str
            //name will have to be dropdown select, request textbox
            Button("Request Save") {
                Task {
                    await modelData.requestSave(date: date)
                }
            }
            .padding()
            Button("Push Dinner") {
                Task {
                    await modelData.pushDinner()
                }
            }
            
        }.onAppear{
            modelData.getSaves()
        }
    }
}

struct SavesView_Previews: PreviewProvider {
    static var previews: some View {
        SavesView().environmentObject(ModelData())
    }
}
