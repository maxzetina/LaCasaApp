//
//  Save.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/23/23.
//

import Foundation

struct Save: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var request: String
    var restrict: String?
}
