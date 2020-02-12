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
        guard let id = dictionnary["id"] as? Int,
            let name = dictionnary["name"] as? String,
            let email = dictionnary["email"] as? String else {
            return nil
        }
        return Author(id: id, name: name, email: email)
    }
}
