//
//  Category.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Category: CustomStringConvertible {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var description: String {
        return "{\(self.name)}"
    }
}
