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
        self.getCategories()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        let alert = UIAlertController(title: "Warning !", message: "Please drink responsibly, we're not responsible of any kind of incudent due to overconsomation of alcohol. Have a nice play with our app anyway :)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Of course", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "I don't agree", style: .destructive, handler: { (action) in
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        }))
        self.present(alert, animated: true)
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
    
    @IBAction func frCreditsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Developpeurs", message: "Developpée avec ❤️ par Julien GUILLAN, Henri GOURGUE er Salayna DOUKOURE.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Meric !", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func creditsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Developers", message: "Developed with ❤️ By Julien GUILLAN, Henri GOURGUE and Salayna DOUKOURE.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Thank you !", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
