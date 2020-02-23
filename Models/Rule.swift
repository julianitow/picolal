//
//  Rule.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Rule: CustomStringConvertible, Encodable {
    
    var id:Int?
    var author: Int
    var category: Int
    var name: String
    var content: String
    var rate: Int
    var drinks: Int
    
    init(name: String, content: String, author: Int, category: Int, rate: Int, drinks: Int) {
        self.name = name
        self.content = content
        self.author = author
        self.category = category
        self.rate = rate
        self.drinks = drinks
    }
    
    init(id: Int, name: String, content: String, author: Int, category: Int, rate: Int, drinks: Int) {
        self.id = id
        self.name = name
        self.content = content
        self.author = author
        self.category = category
        self.rate = rate
        self.drinks = drinks
    }
    
    var description: String {
        return "\(self.name), \(self.content), \(self.author), \(self.category), \(self.rate), \(self.drinks)\n"
    }
}
