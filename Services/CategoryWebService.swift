//
//  Services.swift
//  N3twørk
//
//  Created by Salayna Doukoure on 17/02/2020.
//  Copyright © 2020 ESGI. All rights reserved.
//

import Foundation


class CategoryWebService {
    
    
    
    //- - - - - - - - - - - - - - GET Requests - - - - - - - - - - - - - - //

    func getCategories(completion: @escaping ([Category]) -> Void) -> Void{
        guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/categories") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: ruleURL, completionHandler: { (data: Data?, res, err) in
        guard let bytes = data,
              err == nil,
            let categories = try? JSONDecoder().decode([Category].self,from: bytes)
            else {
                DispatchQueue.main.sync {
                 completion([])
                }
                return
            }
            DispatchQueue.main.sync {
                completion(categories)
            }
            
    })
        task.resume()
    }
    
    
    func getCategoryById(id : Int,completion: @escaping (Category) -> Void) -> Void {
        guard let categoryURL = URL(string: "http://lil-nas.ddns.net:8080/api/category/\(id)") else {
                return;
            }
            let task = URLSession.shared.dataTask(with: categoryURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                let category = try? JSONDecoder().decode(Category.self,from: bytes)
                else {
                    print("The category you're looking for can't be found")
                    return
                }
                DispatchQueue.main.sync {
                    completion(category)
                }
                
        })
            task.resume()
        }
    
    //- - - - - - - - - - - - - - POST Requests - - - - - - - - - - - - - - //
func saveCategory(category: Category, completion: @escaping(Bool) -> Void) -> Void{
    guard let ruleURL = URL(string: "http://lil-nas.ddns.net:8080/api/categories")
        else{
            return;
        }
    var request = URLRequest(url: ruleURL)
    guard let dataToUpload = try? JSONEncoder().encode(category) else{return;}
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
    /*func removeScooter(scooter: Scooter, completion: @escaping (Bool) -> Void) -> Void {
        guard
            let scooterId = scooter.id,
            let scooterURL = URL(string: "https://moc-3a-movies.herokuapp.com/\(scooterId)") else {
            return
        }
        var request = URLRequest(url: scooterURL)
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
    */
    func deleteCategory(category: Category, completion: @escaping (Bool) -> Void) -> Void {
        guard
            let categoryId = category.id,
            let categoryURL = URL(string: "http://lil-nas.ddns.net:8080/api/category/\(categoryId)") else {
            return
        }
        var request = URLRequest(url: categoryURL)
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
   
}
