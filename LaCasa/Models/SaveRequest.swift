//
//  Save.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/21/23.
//

import Foundation

struct SaveRequest: Hashable, Codable {
    var name: String
    var day: String
    var request: String
}
