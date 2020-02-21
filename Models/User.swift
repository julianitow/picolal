//
//  User.swift
//  partyRules
//
//  Created by Julien Guillan on 08/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var name: String
    var email: String
    
    init(id: Int, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
    var description: String {
        return "{\(self.id)), \(self.name), \(self.email)}"
    }
}
