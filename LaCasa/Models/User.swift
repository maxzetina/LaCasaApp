//
//  User.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import Foundation

struct User: Hashable, Codable, Identifiable, Equatable {
    var id: Int?
    var fname: String
    var lname: String
    var kerb: String
    var year: Int
    var major: String
    var dietary_restriction: String
    var password: String?
    var resident: Int
    var onMealPlan: Int
    
    static let `default` = User(id: 0, fname: "DEFAULT", lname: "DEFAULT", kerb: "DEFAULT", year: 0, major: "DEFAULT", dietary_restriction: "DEFAULT", password: "", resident: 0, onMealPlan: 0)
}

struct ResidentInfo: Hashable, Codable {
    var office: String
    var room: Int
    var total_housing_points: Double
    var status1: String
    var status2: String
    var status3: String
    var status4: String
    
    static let `default` = ResidentInfo(office: "", room: 0, total_housing_points: 0, status1: "", status2: "", status3: "", status4: "")
}

//struct Attendance: Hashable, Codable {
//    var status1: String
//    var status2: String
//    var status3: String
//    var status4: String
//}
