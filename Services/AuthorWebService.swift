//
//  Services.swift
//  N3twørk
//
//  Created by Salayna Doukoure on 17/02/2020.
//  Copyright © 2020 ESGI. All rights reserved.
//

import Foundation


class AuthorWebService {
    
    
    
    //- - - - - - - - - - - - - - GET Requests - - - - - - - - - - - - - - //
    
    func getAuthors(completion: @escaping ([Author]) -> Void) -> Void{
        guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/authors") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: ruleURL, completionHandler: { (data: Data?, res, err) in
        guard let bytes = data,
              err == nil,
            let authors = try? JSONDecoder().decode([Author].self,from: bytes)
            else {
                DispatchQueue.main.sync {
                 completion([])
                }
                return
            }
            DispatchQueue.main.sync {
                completion(authors)
            }
            
    })
        task.resume()
    }
    
    
    func getAuthorById(id : Int,completion: @escaping (Author) -> Void) -> Void {
        guard let authorURL = URL(string: "http://lil-nas.ddns.net:8080/api/author/\(id)") else {
                return;
            }
            let task = URLSession.shared.dataTask(with: authorURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                let author = try? JSONDecoder().decode(Author.self,from: bytes)
                else {
                    print("The Author you're looking for can't be found")
                    return
                }
                DispatchQueue.main.sync {
                    completion(author)
                }
                
        })
            task.resume()
        }
    
    //- - - - - - - - - - - - - - POST Requests - - - - - - - - - - - - - - //
    func saveAuthor(author: Author, completion: @escaping(Bool) -> Void) -> Void{
    guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/authors")
        else{
            return;
        }
    var request = URLRequest(url: ruleURL)
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

    
    //- - - - - - - - - - - - - - DELETE Requests - - - - - - - - - - - - - - //
    func deleteAuthor(author: Author, completion: @escaping (Bool) -> Void) -> Void {
        guard
            let authorId = author.id,
            let authorURL = URL(string: "http://lil-nas.ddns.net:8080/api/author/\(authorId)") else {
            return
        }
        var request = URLRequest(url: authorURL)
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
