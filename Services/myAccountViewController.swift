//
//  myAccountViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 08/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class myAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var newRuleTitle: UITextField!
    @IBOutlet weak var newRuleContent: UITextField!
    @IBOutlet weak var drinksPicker: UIPickerView!
    @IBOutlet weak var categoriesPicker: UIPickerView!
    
    
    var pickerDrinksData: [String] = [String]()
    var pickerCategoriesData: [String] = [String]()
    var keyboardVisible = false
    
    let database : Database = Database()
    let ruleWebService : RuleWebService = RuleWebService()
    let authorWebService: AuthorWebService = AuthorWebService()
    var categoryWebService: CategoryWebService = CategoryWebService()
    
    var categories:[Category]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinksPicker.delegate = self
        drinksPicker.dataSource = self
        self.pickerDrinksData = ["1", "2", "3", "4", "5"]
        
        categoriesPicker.delegate = self
        categoriesPicker.dataSource = self
        self.categories.forEach { category in
            self.pickerCategoriesData.append(category.name)
        }
        
        let textFields = self.getAllTextFields(fromView: self.view)
        textFields.forEach({(textField) in
            textField.delegate = self
        })
        // Do any additional setup after loading the view.
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.keyboardVisible == true {
            self.view.endEditing(true) // close all user interaction
            self.keyboardVisible = false
        }
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == drinksPicker {
            return pickerDrinksData.count
        } else {
            return pickerCategoriesData.count
        }
        
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == drinksPicker {
            return pickerDrinksData[row]
        } else {
            return pickerCategoriesData[row]
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotatePortrait()
        
        let db:DBHelper = DBHelper()
        let users : [User] = db.readAll()
        if users.isEmpty {
            //Pas d'utilisateur créé, retour vers la page register/login
            let rvc = RegisterViewController.newInstance()
            navigationController?.pushViewController(rvc, animated: true)
        } else {
            //Utilisateur existant, on reste sur cette page
            inputName.text = users[0].name
            inputEmail.text = users[0].email
        }
        
    }
    class func newInstance(categories: [Category]) -> myAccountViewController{
        let MyAccountViewController = myAccountViewController()
        MyAccountViewController.categories = categories
        return MyAccountViewController
    }
    
    func rotatePortrait(){
        var statusBarOrientation: UIInterfaceOrientation? {
            get {
                guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                    #if DEBUG
                    fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                    #else
                    return nil
                    #endif
                }
                return orientation
            }
        }
        
        if statusBarOrientation!.isLandscape{
            let portrait = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portrait, forKey: "orientation")
        }
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        
        let db:DBHelper = DBHelper()
        let users : [User] = db.readAll()
        
        let newName = inputName.text
        let newMail = inputEmail.text
        let oldName = users[0].name
        let oldMail = users[0].email
        let userId = users[0].id
        
        if (newName == "" && newMail == "") {
            let alert = UIAlertController(title: "Error", message: "Please enter new name or email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            if (newName != oldName || newMail != oldMail) {
                db.deleteByID(id: userId)
                db.insert(id: userId, name: newName!, mail: newMail!)
                let alert = UIAlertController(title: "Success", message: "Successfully updated.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                inputName.text = newName
                inputEmail.text = newMail
            }
        }
    }
    
    @IBAction func showMyRulesAction(_ sender: Any) {
        let db:DBHelper = DBHelper()
        let users : [User] = db.readAll()
        let authorId = users[0].id
        
        self.ruleWebService.getRulesByAuthorId(authorId: authorId) { (rules) in
            let rlvc = RulesViewController.newInstance(rules: rules)
            self.navigationController?.pushViewController(rlvc, animated: true)
        }
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        let db:DBHelper = DBHelper()
        let users : [User] = db.readAll()
        let title = newRuleTitle.text
        let content = newRuleContent.text
        let drinks = pickerDrinksData[drinksPicker.selectedRow(inComponent: 0)]
        let categoryName = pickerCategoriesData[categoriesPicker.selectedRow(inComponent: 0)]
        let categoryId = (categoriesPicker.selectedRow(inComponent: 0) + 1)
        
        if (title == "" || content == "" || drinks == "" || categoryName == "") {
            let alert = UIAlertController(title: "Error", message: "Please fill text fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            let rule = Rule(name: title!, content: content!, author: users[0].id, category: categoryId, rate: 0, drinks: Int(drinks)!)
            self.ruleWebService.createRule(rule: rule){(response) in
                if response == false{
                    //N'a pas fonctionne
                    DispatchQueue.main.async { [weak self] in
                      let alert = UIAlertController(title: "Error", message: "Fail during rule creation.", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self!.present(alert, animated: true)
                    }
                }
                else {
                    //A fonctionne
                    DispatchQueue.main.async { [weak self] in
                      let alert = UIAlertController(title: "Success", message: "Rule created.", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self!.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        let db:DBHelper = DBHelper()
        let users : [User] = db.readAll()
        db.deleteByID(id: users[0].id)
        self.navigationController?.popViewController(animated: true)
    }
}

extension myAccountViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardVisible = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyboardVisible = false
        return false
    }
}
