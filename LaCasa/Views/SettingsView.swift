//
//  SettingsView.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 8/7/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ModelData())
    }
}
