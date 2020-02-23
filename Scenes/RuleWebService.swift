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
    
    func getRuleById(id: Int, completion: @escaping ([Rule]) -> Void) -> Void {
        guard let rulesURL = URL(string: "http://lil-nas.ddns.net:8080/api/rule/" + String(id)) else {
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
    
    
    func createRule(rule: Rule, completion: @escaping(Bool) -> Void){
        guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/rules")
            else{
                return;
            }
        var request = URLRequest(url: ruleURL)
        guard let dataToUpload = try? JSONEncoder().encode(rule) else{return;}
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.uploadTask(with: request, from: dataToUpload){data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let httpRes = response as? HTTPURLResponse {
                completion(httpRes.statusCode == 201)
                return
            }
            completion(false)

        }
        task.resume()
    }
    
    func getRulesByAuthorId(authorId: Int, completion: @escaping ([Rule]) -> Void) -> Void {
        print("ici")
        print(String(authorId))
        guard let rulesURL = URL(string: "http://lil-nas.ddns.net:8080/api/author/" + String(authorId) + "/rules") else {
            return;
        }
        print(rulesURL)
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
            print("ici")
            print(rules)
            DispatchQueue.main.sync {
                completion(rules)
            }
        })
        task.resume()
    }
}
