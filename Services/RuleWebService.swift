//
//  Services.swift
//  N3twørk
//
//  Created by Salayna Doukoure on 17/02/2020.
//  Copyright © 2020 ESGI. All rights reserved.
//

import Foundation


class RuleWebService {
    //- - - - - - - - - - - - - - GET Requests - - - - - - - - - - - - - - //
    
    func getRules(completion: @escaping ([Rule]) -> Void) -> Void{
        guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/rules") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: ruleURL, completionHandler: { (data: Data?, res, err) in
        guard let bytes = data,
              err == nil,
            let rules = try? JSONDecoder().decode([Rule].self,from: bytes)
            else {
                DispatchQueue.main.sync {
                 completion([])
                }
                return
            }
            DispatchQueue.main.sync {
                completion(rules)
            }
            
    })
        task.resume()
    }
    
    func getRuleById(id : Int,completion: @escaping (Rule) -> Void) -> Void {
        guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/rule/\(id)") else {
                return;
            }
            let task = URLSession.shared.dataTask(with: ruleURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                let rule = try? JSONDecoder().decode(Rule.self,from: bytes)
                else {
                    print("The Rule you're looking for can't be found")
                    return
                }
                DispatchQueue.main.sync {
                    completion(rule)
                }
                
        })
            task.resume()
        }
    
    //- - - - - - - - - - - - - - POST Requests - - - - - - - - - - - - - - //
func saveRule(rule: Rule, completion: @escaping(Bool) -> Void) -> Void{
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

    
    //- - - - - - - - - - - - - - DELETE Requests - - - - - - - - - - - - - - //
    func deleteRule(rule: Rule, completion: @escaping (Bool) -> Void) -> Void {
        guard
            let ruleId = rule.id,
            let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/rule/\(ruleId)") else {
            return
        }
        var request = URLRequest(url: ruleURL)
        request.httpMethod = "DELETE"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let httpRes = res as? HTTPURLResponse {
                completion(httpRes.statusCode == 204)
                return
            }
            completion(false)
        })
        task.resume()
    }
    //- - - - - - - - - - - - - - PUT Requests - - - - - - - - - - - - - - //
    
   
}
