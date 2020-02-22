//
//  RateFactory.swift
//  partyRules
//
//  Created by Salayna Doukoure on 20/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation
class RateFactory {
    
    static func rateFrom(dictionnary: [String: Any]) -> Rate? {
        guard let rate = dictionnary["rate"] as? Int,
            let rule = dictionnary["rule"] as? Int else {
            return nil
        }
        return Rate(rate: rate, rule:rule)
    }
}
