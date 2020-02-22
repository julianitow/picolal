//
//  myAccountViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 08/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class myAccountViewController: UIViewController {
    let ruleWebService : RuleWebService = RuleWebService()
    let authorWebService: AuthorWebService = AuthorWebService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        rotatePortrait()
        
        let rule = Rule(name: "Test", content: "Test de content", author: 1, category: 1, rate: 0, drinks: 0)
        self.ruleWebService.createRule(rule: rule){(response) in
            if response == false{
                //N'a pas fonctionne
            }
            else {
                //A fonctionne
            }
        }
        
        let author = Author(id: 99, name: "Jean", email: "jeanValJean@gmail.Com")
        self.authorWebService.createAuthor(author: author){(response) in
            if response == false{
                //N'a pas fonctionne
            }
            else {
                //A fonctionne
            }
        }
    }
    class func newInstance() -> myAccountViewController{
        let MyAccountViewController = myAccountViewController()
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

}
