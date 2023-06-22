//
//  ContentView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        VStack{
            ForEach(modelData.chores, id: \.kerb) { chore in
                Text(chore.fname)
            }
            Button("Request Save") {
                Task {
                    await modelData.requestSave()
                }
            }
            
        }.onAppear{
            modelData.getChores()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ModelData())
    }
}
