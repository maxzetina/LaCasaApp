//
//  ChoreRow.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/25/23.
//

import SwiftUI

struct ChoreRow: View {
    var chore: Chore
    
    var body: some View {
        VStack(alignment: .leading){
            Text(chore.fname).font(.headline)
            Spacer()
            Text(chore.chore).font(.subheadline).opacity(0.7)
        }.lineLimit(1).frame(height: 50).padding(4.0)
    }
}
        
struct ChoreRow_Previews: PreviewProvider {
    static var previews: some View {
        ChoreRow(chore: Chore(fname: "Maxwell", lname: "Zetina", kerb: "zetina", team: 1, chore: "CHORE", chores_completed: 3))
    }
}
