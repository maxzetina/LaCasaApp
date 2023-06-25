//
//  Saves.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI

struct SavesView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var date = Date()

    var body: some View {
        VStack{
            ForEach(modelData.saves, id: \.name) { save in
                Text(save.name)
            }
            
            DatePicker(
                "Start Date",
                selection: $date,
                displayedComponents: [.date]
            ).padding()

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
