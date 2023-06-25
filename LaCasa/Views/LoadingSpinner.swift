//
//  LoadingSpinner.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/23/23.
//

import SwiftUI

struct LoadingSpinner: View {
    var text: String
    var scale: Int
    @State var scaleEffect: CGSize = CGSize(width: 1, height: 1)

    var body: some View {
        VStack{
            ProgressView(text).scaleEffect(scaleEffect).progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        
        }.onAppear{
            scaleEffect = CGSize(width: scale, height: scale)
        }
    }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinner(text: "Loading [Text]...", scale: 2)
    }
}
