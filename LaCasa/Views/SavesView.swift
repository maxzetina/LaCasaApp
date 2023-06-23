//
//  Saves.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI

struct SavesView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack{
//            if modelData.loadingChores {
//                Text("Loading...")
//            }
            ForEach(modelData.saves, id: \.name) { save in
                Text(save.name)
            }
            Button("Request Save") {
                Task {
                    await modelData.requestSave()
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
