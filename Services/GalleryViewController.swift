//
//  GalleryViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    let ruleWebService: RuleWebService = RuleWebService()
    let authorWebService: AuthorWebService = AuthorWebService()
    let database: Database = Database()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotatePortrait()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func playAction(_ sender: Any) {
        let pvc = PlayersViewController.newInstance()
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    /*@IBAction func showRulesAction(_ sender: Any) {
        self.ruleWebService.getRules { (rules) in
            let rlvc = RulesViewController.newInstance(rules: rules)
            self.navigationController?.pushViewController(rlvc, animated: true)
        }
    }*/
    
    @IBAction func myAccountAction(_ sender: Any) {
        authorWebService.getAuthor(id: 1) { (Author) in
            let user: User = User(id: Author[0].id, name: Author[0].name, email: Author[0].email)
            self.database.create(user: user)
            /*self.database.create(user: user)
            let user2 = try?self.database.read(email: "guillan.julien@live.com")
             print(user2?.description)*/
            let myAccountPage = myAccountViewController.newInstance()
            self.navigationController?.pushViewController(myAccountPage, animated: true)
            
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
