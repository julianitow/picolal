//
//  CategorySelectionViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 20/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class CategorySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryWebService: CategoryWebService = CategoryWebService()
    var categories:[Category]!
    var players:[String]!
    
    enum Identifier: String {
        case categories
    }

    @IBOutlet var categoriesTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotatePortrait()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.delegate = self
        self.categoriesTableView.backgroundColor = UIColor(displayP3Red: (25/255), green: (118/255), blue: (210/255), alpha: 0)
    }
    
    class func newInstance(players: [String], categories: [Category]) -> CategorySelectionViewController {
        let csvc = CategorySelectionViewController()
        csvc.categories = categories
        csvc.players = players
        return csvc
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let category = self.categories[indexPath.section]
        
        cell.nameLabel.text = category.name
        cell.descriptionLabel.text = category.description
        
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categories[indexPath.section]
        let ruleDetails = RuleDetailsViewController.newInstance(players: self.players, category: category.name)
        self.navigationController?.pushViewController(ruleDetails, animated: true)
    }
    
    /*func getCategories(){
        self.categoryWebService.getCategories { (rules) in
            self.rules = rules
            let index = self.randomNumber(min: 0, max: rules.count)
            let indexPlayer = self.randomNumber(min: 0, max: self.players.count)
            self.display(rule: self.rules[index], player: self.players[indexPlayer])
            self.rules.remove(at: index)
        }
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
