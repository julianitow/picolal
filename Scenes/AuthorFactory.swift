//
//  AuthorFactory.swift
//  partyRules
//
//  Created by Julien Guillan on 06/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class AuthorFactory {
    static func authorFrom(dictionnary: [String: Any]) -> Author? {
        let id: Int? = dictionnary["id"] as? Int
        
        guard
            let name = dictionnary["name"] as? String,
            let email = dictionnary["email"] as? String else {
            return nil
        }
        if id != nil {
            return Author(id: id!, name: name, email: email)
        } else {
            return Author(name: name, email: email)
        }
        
    }

}
