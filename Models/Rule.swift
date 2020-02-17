//
//  Rule.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

struct Rule : Codable{
    let id       : Int?
    let name     : String
    let content  : String
    let category : Category
    let author   : Author
}

/*class Rule: CustomStringConvertible {
    var author: Int
    var category: Int
    var name: String
    var content: String
    
    
    init(name: String, content: String, author: Int, category: Int) {
        self.name = name
        self.content = content
        self.author = author
        self.category = category
    }
    
    var description: String {
        return "\(self.name), \(self.content), \(self.author), \(self.category)\n"
    }
}*/
