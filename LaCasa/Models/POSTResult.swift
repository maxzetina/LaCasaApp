//
//  POSTResult.swift
//  LaCasa
//
//  Created by Maxwell Zetina on 7/31/23.
//

import Foundation

struct POSTResult: Codable, Hashable {
    var successful: Bool
    var errorMsg: String
}
