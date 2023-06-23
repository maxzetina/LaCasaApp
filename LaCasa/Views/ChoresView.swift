//
//  Chores.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI

struct ChoresView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack{
            if modelData.loadingChores {
                LoadingSpinner(text: "Loading chores...", scale: 2)
            }
            
            ForEach(modelData.chores, id: \.kerb) { chore in
                Text(chore.fname)
            }
            
        }.onAppear{
            modelData.getChores()
        }
    }
}

struct ChoresView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresView().environmentObject(ModelData())
    }
}
