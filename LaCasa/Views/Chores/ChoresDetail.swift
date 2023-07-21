//
//  ChoresDetail.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/28/23.
//

import SwiftUI

struct ChoresDetail: View {
    var chore: Chore
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Chore")
                    .font(.largeTitle).foregroundColor(Color("ChoreDetailColor")).bold().padding(.bottom)
                Text(chore.chore)
                    .font(.title).padding(.bottom)
                Divider()
                Text("Description")
                    .font(.largeTitle).foregroundColor(Color("ChoreDetailColor")).bold()
                Text(chore.description).padding(.top).font(.title2)
                
                Spacer()
            }.navigationTitle(chore.kerb).navigationBarTitleDisplayMode(.inline).padding()
        }
    }
}

struct ChoresDetail_Previews: PreviewProvider {
    static var previews: some View {
        ChoresDetail(chore: Chore(id: 100, fname: "Maxwell", lname: "Zetina", kerb: "zetina", team: 1, chore: "CHORE", chores_completed: 3, description: "do this"))
    }
}
