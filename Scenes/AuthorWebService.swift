//
//  AuthorWebService.swift
//  partyRules
//
//  Created by Julien Guillan on 06/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class AuthorWebService {
    
    func getAuthor(id: Int, completion: @escaping ([Author]) -> Void) -> Void {
        guard let authorURL = URL(string: "http://lil-nas.ddns.net:8080/api/author/" + String(id)) else {
            return;
        }
        let task = URLSession.shared.dataTask(with: authorURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .fragmentsAllowed) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            let author = json.compactMap { (obj) -> Author? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return AuthorFactory.authorFrom(dictionnary: dict)
            }
            DispatchQueue.main.sync {
                completion(author)
            }
        })
        task.resume()
    }
    
    func createAuthor(author: Author, completion: @escaping(Bool) -> Void) -> Void{
        guard let authorURL = URL(string: "http://lil-nas.ddns.net:8080/api/authors")
            else{
                return;
            }
        var request = URLRequest(url: authorURL)
        guard let dataToUpload = try? JSONEncoder().encode(author) else{return;}
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
