//
//  Rate.swift
//  partyRules
//
//  Created by Salayna Doukoure on 20/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Rate: CustomStringConvertible, Encodable {
    var rate : Int
    var rule : Int
    
    init(rate: Int, rule: Int) {
        self.rate = rate
        self.rule = rule
    }
    
    var description: String {
        return "\(self.rate),\(self.rule)\n"
    }
}
