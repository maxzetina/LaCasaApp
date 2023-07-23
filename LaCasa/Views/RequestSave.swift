//
//  RequestSave.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/23/23.
//

import SwiftUI

struct RequestSave: View {
    @Binding var showRequstSaveSheet: Bool
    
    @EnvironmentObject var modelData: ModelData
    @State private var date = Date()
    @State var name = ""

    var body: some View {
        NavigationView{
            VStack{
                TextField("name", text: $name)
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                ).padding()

                //name, day, request - all str
                //name will have to be dropdown select, request textbox
                Button("Request Save") {
                    Task {
                        await modelData.requestSave(date: date)
                    }
                }
                .padding()

            }.navigationTitle("Request Save")
            .toolbar {
                ToolbarItemGroup() {
                    Button("Cancel",
                           action: { showRequstSaveSheet.toggle() })
                }
            }
        }
    }
}

struct RequestSave_Previews: PreviewProvider {
    static var previews: some View {
        RequestSave(showRequstSaveSheet: .constant(true)).environmentObject(ModelData())
    }
}
