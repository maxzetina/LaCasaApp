//
//  Save.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/23/23.
//

import Foundation

struct Save: Hashable, Codable {
    var name: String
    var request: String
    var restrict: String?
}
