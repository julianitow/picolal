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
    var categoryWebService: CategoryWebService = CategoryWebService()
    let database: Database = Database()
    var categories: [Category]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.getCategories()
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
            let myAccountPage = myAccountViewController.newInstance(categories: self.categories)
            self.navigationController?.pushViewController(myAccountPage, animated: true)
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
    
    func getCategories() {
        self.categoryWebService.getAllCategories { (categories) in
            self.categories = categories
        }
    }
}
