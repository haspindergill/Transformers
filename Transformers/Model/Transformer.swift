
//
//  Transformer.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-11.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation

struct Transformer: Codable {
    var courage: Int
    var endurance: Int
    var firepower: Int
    let id: String
    var intelligence: Int
    var rank: Int
    var skill: Int
    var speed: Int
    var strength: Int
    var team: String
    var name: String
    var teamIcon: String?
}

struct Transformers: Codable {
    let transformers: [Transformer]
}
