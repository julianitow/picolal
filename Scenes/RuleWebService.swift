//
//  RuleWebService.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class RuleWebService {
    
    func getRules(completion: @escaping ([Rule]) -> Void) -> Void {
        guard let rulesURL = URL(string: "http://lil-nas.ddns.net:8080/api/rules") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: rulesURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            let rules = json.compactMap { (obj) -> Rule? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return RuleFactory.ruleFrom(dictionnary: dict)
            }
            DispatchQueue.main.sync {
                completion(rules)
            }
        })
        task.resume()
    }
    
    func getRulesByCategory(categoryName: String, completion: @escaping ([Rule]) -> Void) -> Void {
        guard let rulesURL = URL(string: "http://lil-nas.ddns.net:8080/api/category/" + categoryName + "/rules") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: rulesURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            let rules = json.compactMap { (obj) -> Rule? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return RuleFactory.ruleFrom(dictionnary: dict)
            }
            DispatchQueue.main.sync {
                completion(rules)
            }
        })
        task.resume()
    }
}
