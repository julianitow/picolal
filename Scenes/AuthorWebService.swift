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
}
