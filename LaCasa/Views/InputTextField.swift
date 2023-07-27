//
//  InputTextField.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/26/23.
//

import SwiftUI

struct InputTextField: View {
    var placeholderText: String
    var width: CGFloat = 300
    @Binding var input: String
    var img: Image?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10).frame(width: width, height: 50).foregroundColor(.gray).opacity(0.25).overlay(
            HStack{
                if(img != nil){
                    img.padding(.leading)
                }
                TextField(placeholderText, text: $input)   .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.leading, img != nil ? 4.0 : 12.0)
            }
        ).padding(.bottom, 4.0)
    }
}

struct InputTextField_Previews: PreviewProvider {
    static var previews: some View {
        InputTextField(placeholderText: "placeholder", width: 300, input: .constant("Some Input"), img: Image(systemName: "person.fill"))
    }
}
