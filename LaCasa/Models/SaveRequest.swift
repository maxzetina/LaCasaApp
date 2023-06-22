//
//  Save.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 6/21/23.
//

import Foundation

class SaveRequest: Codable {
    static func == (lhs: SaveRequest, rhs: SaveRequest) -> Bool {
        return false
    }
    
    public var name: String
    public var day: String
    public var request: String
    
    init(name: String, day: String, request: String) {
        self.name = name
        self.day = day
        self.request = request
    }
}
