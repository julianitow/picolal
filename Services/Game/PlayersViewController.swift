//
//  PlayersViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 19/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    
    let categoryWebService = CategoryWebService()
    var categories: [Category]!
    var keyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        getCategories()
        let textfields = getAllTextFields(fromView: self.view)
        textfields.forEach({(textField) in
            textField.delegate = self
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotatePortrait()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    class func newInstance() -> PlayersViewController{
        let pvc = PlayersViewController()
        
        return pvc
    }

    @IBAction func playAction(_ sender: Any) {
        let textFields = getAllTextFields(fromView: self.view)
        var nbPlayers = 0
        var players: [String] = []
        textFields.forEach({ (textField) in
            if(textField.text!.count > 0){
                nbPlayers += 1
                players.append(textField.text!)
            }
        })
        if(nbPlayers == 0){
            self.alert(title: "Is there anybody ?", message: "You obvisously can't play without any player ;)", action: "Oups sorry !")
        } else if(nbPlayers == 1){
            self.alert(title: "No friends ? ", message: "There is no PMU mode yet. :/", action: "Oh Damn !")
        } else {
            let csvc = CategorySelectionViewController.newInstance(players: players, categories: self.categories)
            navigationController?.pushViewController(csvc, animated: true)
        }
    }
    
    func alert(title: String, message: String, action: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true)
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
    
    func getCategories(){
        self.categoryWebService.getAllCategories(completion: {(categories) in
            self.categories = categories
        })
        
    }
    

   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.keyboardVisible == true {
            self.view.endEditing(true) // close all user interaction
            self.keyboardVisible = false
        }
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

}

extension PlayersViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardVisible = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyboardVisible = false
        return false
    }
}
