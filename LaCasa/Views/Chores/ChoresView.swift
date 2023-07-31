//
//  Chores.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/22/23.
//

import SwiftUI

struct ChoresView: View {
    @EnvironmentObject var modelData: ModelData
    var dueDate: String = next(self: Date(), weekday: Weekday.sunday, considerToday: true)
    
    @State var listAnimationTrigger = false
    
    var body: some View {
        VStack{
            if modelData.loadingChores {
                LoadingSpinner(text: "Loading chores...", scale: 2, tint: .blue)
            }
            else{
                NavigationView{
                    List{
                        Section{
                            ChoresIntro(team: modelData.currentTeam, dueDate: dueDate)
                    
                        }
                    
                        Section{
                            ForEach(modelData.chores) { chore in
                                    NavigationLink {
                                        ChoresDetail(chore: chore)
                                    } label: {
                                        ChoreRow(chore: chore)
                                    }
                            }
                        }.opacity(self.listAnimationTrigger ? 1.0 : 0.0).onAppear(){
                            withAnimation(.linear(duration: 2)){
                                self.listAnimationTrigger = true
                            }
                        }
                    }.navigationTitle("Chores")
                }.navigationViewStyle(StackNavigationViewStyle())
            }
            
        }.onAppear{
            modelData.getChores()
        }
    }
}

func next(self: Date,
    weekday: Weekday,
                 direction: Calendar.SearchDirection = .forward,
                 considerToday: Bool = false) -> String
{
    
    var nextDate = self
    
    let calendar = Calendar(identifier: .gregorian)
    let components = DateComponents(weekday: weekday.rawValue)

    if considerToday &&
        calendar.component(.weekday, from: self) == weekday.rawValue
    {
        return nextDate.formatted(.dateTime.day().month().weekday())
    }

    nextDate = calendar.nextDate(after: self,
                             matching: components,
                             matchingPolicy: .nextTime,
                             direction: direction)!
    return nextDate.formatted(.dateTime.day().month().weekday())
    
}

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

struct ChoresView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresView().environmentObject(ModelData())
    }
}
