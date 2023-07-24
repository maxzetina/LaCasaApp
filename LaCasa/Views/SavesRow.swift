//
//  SavesRow.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/22/23.
//

import SwiftUI

struct SavesRow: View {
    var save: Save
    
    @State var showRequestPopover = false
    
    var body: some View {
        HStack(alignment: .top){
            VStack(alignment: .leading){
                Text("\(save.fname) \(save.lname)").font(.headline)
                Spacer()
                Text(save.dietary_restriction).font(.subheadline).opacity(0.7).italic()
            }.frame(height: 50)
            
            Spacer()
            
            if(save.request != ""){
                Button(action: { showRequestPopover = true })
                {
                    Image(systemName: "bubble.left.fill").foregroundColor(Color("LoginButtonColor"))
                }.popover(isPresented: $showRequestPopover) {
                    Text(save.request).padding()                    .presentationCompactAdaptation(.popover)
                }
            }

        }.padding(4.0)
    }
}

struct SavesRow_Previews: PreviewProvider {
    static var previews: some View {
        SavesRow(save: Save(id: 100, fname: "Maxwell", lname: "Zetina-Jimenez", kerb: "zetina", request: "Extra chicken please", dietary_restriction: "Gluten Free"))
    }
}
