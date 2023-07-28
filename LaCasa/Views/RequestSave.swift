//
//  RequestSave.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/23/23.
//

import SwiftUI

struct RequestSave: View {
    @Binding var showRequestSaveSheet: Bool
    
    @EnvironmentObject var modelData: ModelData
    @State var multiselect: Bool = false
    @State private var singleDate = Date()
    @State var multipleDates: Set<DateComponents> = [Calendar.current.dateComponents([.calendar, .era, .day, .month, .year], from: Date() as Date)]
    
    @State var openDatePicker: Bool = false
    var body: some View {
        NavigationView{
            VStack{
                Toggle(isOn: $multiselect) {
                    Text("Multiselect").font(.title3)
                }.padding()
                
                Button(action: {
                    openDatePicker.toggle()
                }, label: {
                    Image(systemName: "chevron")
                })
                
                if(openDatePicker){
                    if(multiselect){
                        MultiDatePicker("Select dates for saves", selection: $multipleDates).fixedSize()
                    }
                    else {
                        DatePicker(
                            "Start Date",
                            selection: $singleDate,
                            displayedComponents: [.date]
                        ).datePickerStyle(.graphical).padding(.bottom, 8.0)
                    }
                }
                
                                
                Button("Request Save") {
                    let _ = print(multipleDates)
//                    Task {
//                        await modelData.requestSave(kerb: modelData.user.kerb, date: date, request: "request")
//                    }
                }.padding()
                
                Spacer()
            }.navigationTitle("Request Save")
            .toolbar {
                ToolbarItemGroup() {
                    Button("Cancel",
                           action: { showRequestSaveSheet.toggle() })
                }
            }
        }
    }
}

struct RequestSave_Previews: PreviewProvider {
    static var previews: some View {
        RequestSave(showRequestSaveSheet: .constant(true)).environmentObject(ModelData())
    }
}
