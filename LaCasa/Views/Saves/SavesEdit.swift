//
//  SavesEdit.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/30/23.
//

import SwiftUI

struct SavesEdit: View {
    @Binding var showEditSavesSheet: Bool
    var savesDate: Date
    
    @EnvironmentObject var modelData: ModelData
    @State var multipleDates: Set<DateComponents> = []
    @State var initialDates: Set<String> = []
    @State var dateToSave: Dictionary<String, Save> = [:]
    @State var comment: String =  ""
    @FocusState var isCommentInputActive: Bool
    @State var submitPressed: Bool = false
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    MultiDatePicker("Select dates for saves", selection: $multipleDates, in: Date()...)
                    
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

                        var selectedDates: Set<String> = Set()
                        
                        for dateComp in multipleDates {
                            let date = Calendar.current.date(from: dateComp)
                            let dateStr = modelData.dateToString(date: date!)
                            selectedDates.insert(dateStr)
                        }
                        
                        //dates that are not in the intersection of set A and B
                        for date in selectedDates.symmetricDifference(initialDates) {
                            // new date = new save
                            if(!initialDates.contains(date)){
                                await modelData.requestSave(date: date, request: comment)
                            }
                            else {
                                let save = dateToSave[date]
                                await modelData.deleteSave(saveId: save!.id)
                            }
                        }

                        submitPressed.toggle()
                        modelData.getSaves(date: savesDate)
                        showEditSavesSheet.toggle()
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10).frame(width: 300, height: 50).foregroundColor(.blue).shadow(radius: 10).overlay(
                        
                        VStack{
                            if(submitPressed){
                                ProgressView().scaleEffect(1.5).progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            else{
                                Text("Update Saves").foregroundColor(.white).fontWeight(.bold).font(.title3)
                            }
                        }
                    )
              
                }).padding().listRowBackground(Color.clear)
            }.navigationTitle("My Saves")
            .toolbar {
                ToolbarItemGroup() {
                    Button("Cancel",
                           action: { showEditSavesSheet.toggle() })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle()).onAppear{
                Task{
                    await modelData.getUserSaves()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    for save in modelData.userSaves {
                        let parsedDate = String(save.day.prefix(10))
                        let date = dateFormatter.date(from: parsedDate)
                        let dateComp = Calendar.current.dateComponents([.calendar, .era, .day, .month, .year], from: date! as Date)
                        multipleDates.insert(dateComp)
                        initialDates.insert(parsedDate)
                        dateToSave[parsedDate] = save
                    }
                }
        }
    }
}
struct SavesEdit_Previews: PreviewProvider {
    static var previews: some View {
        SavesEdit(showEditSavesSheet: .constant(true), savesDate: Date()).environmentObject(ModelData())
    }
}
