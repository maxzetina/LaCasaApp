//
//  RequestSave.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/23/23.
//

import SwiftUI

struct RequestSave: View {
    @Binding var showRequestSaveSheet: Bool
    var savesDate: Date
    
    @EnvironmentObject var modelData: ModelData
    @State var multiselect: Bool = false
    @State private var singleDate = Date()
    @State var multipleDates: Set<DateComponents> = [Calendar.current.dateComponents([.calendar, .era, .day, .month, .year], from: Date() as Date)]
    
    @State var comment: String =  ""
    @FocusState var isCommentInputActive: Bool
    @State var submitPressed: Bool = false
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Toggle(isOn: $multiselect) {
                        Text("Select Multiple Dates").font(.headline)
                    }.tint(.blue).padding()
                    
                    if(multiselect){
                        MultiDatePicker("Select dates for saves", selection: $multipleDates,                             in: Date()...)
                    }
                    else {
                        HStack{
                            Text("Date").font(.headline)
                            Spacer()
                            DatePicker(
                                "Saves",
                                selection: $singleDate,
                                in: Date()...,
                                displayedComponents: [.date]
                            ).datePickerStyle(.automatic).labelsHidden()
                        }.padding()
                    }
                    
                    VStack(alignment: .leading){
                        Text("Special Request").font(.headline).padding(.bottom, 8.0)
                        TextField("Ex. Extra rice", text: $comment, axis: .vertical).font(comment.isEmpty ? Font.body.italic() : .body).padding().toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button("Done") {
                                    if isCommentInputActive {
                                        isCommentInputActive = false
                                    }
                                }
                            }
                        }.focused($isCommentInputActive).overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(style: StrokeStyle(lineWidth: 1.0)))
                    }.padding()
                }
                
                
                Button(action: {
                    Task{
                        submitPressed.toggle()
                        
//                        var selectedDates: [Date] = [singleDate]
//                        
//                        if(multiselect){
//                            selectedDates = multipleDates
//                                .compactMap { date in
//                                    Calendar.current.date(from: date)
//                                }
//                        }
           
//                        for date in selectedDates {
//                            await modelData.requestSave(kerb: modelData.user.kerb, date: date, request: comment)
//                        }
                        submitPressed.toggle()
                        modelData.getSaves(date: savesDate)
                        showRequestSaveSheet.toggle()
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.blue).shadow(radius: 10).overlay(
                        
                        VStack{
                            if(submitPressed){
                                ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            else{
                                Text("Request Save").foregroundColor(.white).fontWeight(.bold).font(.title3)
                            }
                        }
                    )
              
                }).padding().listRowBackground(Color.clear)
            }.navigationTitle("Request Save")
            .toolbar {
                ToolbarItemGroup() {
                    Button("Cancel",
                           action: { showRequestSaveSheet.toggle() })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct RequestSave_Previews: PreviewProvider {
    static var previews: some View {
        RequestSave(showRequestSaveSheet: .constant(true), savesDate: Date()).environmentObject(ModelData())
    }
}
