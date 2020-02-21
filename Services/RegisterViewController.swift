//
//  RegisterViewController.swift
//  partyRules
//
//  Created by Salayna Doukoure on 21/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let database : Database = Database()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    class func newInstance() -> RegisterViewController{
           let registerViewController = RegisterViewController()
           return registerViewController
       }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func registerButton(_ sender: Any) {
        let userName = self.nameTextField.text
        let userMail = self.mailTextField.text
        let user = User(id: 1, name: userName ?? "John", email: userMail ?? "Doe@doe.com")
        let db:DBHelper = DBHelper()
       // db.insert(id: 2, name: "Jojo", mail: "testdb@db.com")
        db.read(id:2)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
