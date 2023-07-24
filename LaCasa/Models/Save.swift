//
//  Save.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/23/23.
//

import Foundation

struct Save: Hashable, Codable, Identifiable {
    var id: Int
    var fname: String
    var lname: String
    var kerb: String
    var request: String
    var dietary_restriction: String
}
