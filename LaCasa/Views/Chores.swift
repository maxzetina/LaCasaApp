//
//  Chores.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI

struct Chores: View {
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

struct Chores_Previews: PreviewProvider {
    static var previews: some View {
        Chores().environmentObject(ModelData())
    }
}
