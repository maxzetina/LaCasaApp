//
//  Chore.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/21/23.
//

import Foundation

struct Chore: Hashable, Codable, Identifiable {
    var id: Int
    var fname: String
    var lname: String
    var kerb: String
    var team: Int
    var chore: String
    var chores_completed: Int
    var description: String
}
