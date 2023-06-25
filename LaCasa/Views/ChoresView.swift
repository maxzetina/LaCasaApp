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
            else{
                NavigationView{
                    List{
                        ChoresIntro()
                        
                        ForEach(modelData.chores, id: \.kerb) { chore in
                                NavigationLink {
                                    Text(chore.chore)
                                } label: {
                                    ChoreRow(chore: chore)
                                }
                        }
                    }.navigationTitle("Chores")
                }
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
