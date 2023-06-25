//
//  ChoresIntro.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/24/23.
//

import SwiftUI

struct ChoresIntro: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                ZStack{
                    Capsule().frame(width: 150, height: 50)
                    
                    Text("Team 1").foregroundColor(.white).font(.title).fontWeight(.bold)
                }
                Spacer()
            }.padding()

            HStack{
                Text("Due:").bold()
                Text("Sun Jun 25 @ 1:00pm").foregroundColor(.red)
            }.font(.title3).fontWeight(.medium)
        }
    }
}

struct ChoresIntro_Previews: PreviewProvider {
    static var previews: some View {
        ChoresIntro()
    }
}
