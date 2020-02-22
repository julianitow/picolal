//
//  RateWebService.swift
//  partyRules
//
//  Created by Salayna Doukoure on 20/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation
class RateWebService{
    func createRate(rate: Rate, completion: @escaping(Bool) -> Void){
         guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/rates")
             else{
                 return;
             }
         var request = URLRequest(url: ruleURL)
         guard let dataToUpload = try? JSONEncoder().encode(rate) else{return;}
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
}
