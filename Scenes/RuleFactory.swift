//
//  RuleFactory.swift
//  partyRules
//
//  Created by Julien Guillan on 12/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class RuleFactory {
    
    static func ruleFrom(dictionnary: [String: Any]) -> Rule? {
        guard let name = dictionnary["name"] as? String,
            let content = dictionnary["content"] as? String,
            let authorId = dictionnary["author"] as? Int,
            let rate = dictionnary["rate"] as? Int,
            let drinks = dictionnary["drinks"] as? Int,
            let categoryId = dictionnary["category"] as? Int else {
            return nil
        }
        return Rule(name: name, content: content, author: authorId, category: categoryId, rate: rate, drinks: drinks)
    }
}


