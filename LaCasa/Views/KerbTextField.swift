//
//  KerbTextField.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/20/23.
//

import SwiftUI

struct KerbTextField: View {
    @Binding var kerb: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
            HStack{
                Image(systemName: "person.fill").padding(.leading)
                
                TextField("kerb", text: $kerb)   .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.leading, 4.0)
            }
        ).padding(.bottom, 4.0)
    }
}

struct KerbTextField_Previews: PreviewProvider {
    static var previews: some View {
        KerbTextField(kerb: .constant("KERB"))
    }
}
