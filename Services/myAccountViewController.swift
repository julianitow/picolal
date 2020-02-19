//
//  myAccountViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 08/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class myAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

        if UIApplication.shared.statusBarOrientation.isLandscape {
            let portrait = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portrait, forKey: "orientation")
        }
        
        let rule = Rule(name: "Test", content: "Test de content", author: 1, category: 1, rate: 0, drinks: 0)
        createRule(rule: rule){(response) in
            if response == false{
                //N'a pas fonctionne
            }
            else {
                //A fonctionne
            }
        }
        
        let author = Author(id: 99, name: "Jean", email: "jeanValJean@gmail.Com")
        createAuthor(author: author){(response) in
            if response == false{
                //N'a pas fonctionne
            }
            else {
                //A fonctionne
            }
        }
    }
    
    func createRule(rule: Rule, completion: @escaping(Bool) -> Void){
        guard let ruleURL = URL(string: "http://192.168.1.24:8080/api/rules")
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
    
    func createAuthor(author: Author, completion: @escaping(Bool) -> Void) -> Void{
        guard let authorURL = URL(string: "http://192.168.1.24:8080/api/authors")
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
    
    class func newInstance() -> myAccountViewController{
        let MyAccountViewController = myAccountViewController()
        return MyAccountViewController
    }

}
