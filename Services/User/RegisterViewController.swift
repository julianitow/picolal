//
//  RegisterViewController.swift
//  partyRules
//
//  Created by Henri GOURGUE on 22/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameInputText: UITextField!
    @IBOutlet weak var emailInputText: UITextField!
    var keyboardVisible = false
    let database : Database = Database()
    let authorWebService: AuthorWebService = AuthorWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameInputText.delegate = self
        self.emailInputText.delegate = self
    }
    
    class func newInstance() -> RegisterViewController{
        let rvc = RegisterViewController()
        return rvc
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if nameInputText.text == "" || emailInputText.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter name and email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let name = self.nameInputText.text
            let email = self.emailInputText.text
            
            let db:DBHelper = DBHelper()
            
            self.getNextAuthorId(){(nextAuthorId) in
                print(nextAuthorId)
                let author = Author(id: nextAuthorId, name: name!, email: email!)
                let authorApi = Author(name: name!, email: email!)
                self.authorWebService.createAuthor(author: authorApi){(response) in
                    if !response{
                        //N'a pas fonctionne
                        print(response)
                    }
                    else {
                        //A fonctionne
                        db.insert(id: author.id!+1, name: name!, mail: email!)
                        DispatchQueue.main.async {
                            self.changeView()
                        }
                        //db.insert(id: author.id, name: name, mail: email)
                    }
                }
            }
        }
    }
    
    func changeView(){
        let mavc = myAccountViewController.newInstance()
        self.navigationController?.pushViewController(mavc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.keyboardVisible == true {
            self.view.endEditing(true) // close all user interaction
            self.keyboardVisible = false
        }
    }
    
    func getNextAuthorId(completion: @escaping (Int) -> Void) -> Void {
        guard let rulesURL = URL(string: "http://lil-nas.ddns.net:8080/api/author/nextAuthor") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: rulesURL, completionHandler: { (data: Data?, res, err) in
            let stringInt = String.init(data: data!, encoding: String.Encoding.utf8)
            let int = Int.init(stringInt ?? "")

            completion(int!)

        })
        task.resume()
    }
    
}
    
    
extension RegisterViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardVisible = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.nameInputText {
            return self.emailInputText.becomeFirstResponder() // ouverture du clavier
        }
        
        self.keyboardVisible = false
        return false
    }
}
