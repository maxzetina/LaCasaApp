//
//  ChoresIntro.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/24/23.
//

import SwiftUI

struct ChoresIntro: View {
    var team: Int
    var dueDate: String
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                ZStack{
                    Capsule().frame(width: 150, height: 50)
                    
                    Text("Team " + String(team)).foregroundColor(.white).font(.title).fontWeight(.bold)
                }
                Spacer()
            }.padding()

            HStack{
                Text("Due:").bold()
                Text(dueDate + " @ 1:00pm").foregroundColor(.red)
            }.font(.title3).fontWeight(.medium)
        }
    }
}

struct ChoresIntro_Previews: PreviewProvider {
    static var previews: some View {
        ChoresIntro(team: 1, dueDate: "Sun, Jun 25")
    }
}
