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
    @State var namePicked = ""
    @State private var date = Date()

    var body: some View {
        NavigationView{
            VStack{
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                ).padding()
//                Picker("", selection: $kerb){
//                    ForEach(modelData.residents){
//                        resident in
//                        Text(resident.kerb)
//                    }
//                }
                Button("Request Save") {
                    Task {
                        await modelData.requestSave(kerb: "zetina", date: date, request: "request")
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
        }.onAppear{
//            modelData.getPeople()
        }
    }
}

struct RequestSave_Previews: PreviewProvider {
    static var previews: some View {
        RequestSave(showRequstSaveSheet: .constant(true)).environmentObject(ModelData())
    }
}
