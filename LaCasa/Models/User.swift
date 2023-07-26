//
//  User.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/19/23.
//

import Foundation

struct User: Hashable, Codable {
    var id: Int?
    var fname: String
    var lname: String
    var kerb: String
    var year: Int
    var major: String
    var dietary_restriction: String
    var password: String
    var resident: Int
    
    static let `default` = User(id: 0, fname: "", lname: "", kerb: "", year: 0, major: "", dietary_restriction: "", password: "", resident: 0)

}
