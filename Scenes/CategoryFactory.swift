//
//  CategoryFactory.swift
//  partyRules
//
//  Created by Julien Guillan on 06/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class CategoryFactory {
    static func categoryFrom(dictionnary: [String: Any]) -> Category? {
        guard let id = dictionnary["id"] as? Int,
            let name = dictionnary["name"] as? String,
            let description = dictionnary["description"] as? String else {
            return nil
        }
        return Category(id: id, name: name, description: description)
    }
}
