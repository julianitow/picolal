//
//  RulesViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 26/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var authorWebService: AuthorWebService = AuthorWebService()
    var categoryWebService: CategoryWebService = CategoryWebService()
    var rules:[Rule]!
    
    enum Identifier: String {
        case rules
    }
    
    @IBOutlet var rulesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rulesTableView.register(UINib(nibName: "RuleTableViewCell", bundle: nil), forCellReuseIdentifier: "RuleCell")
        self.rulesTableView.dataSource = self
        self.rulesTableView.delegate = self
        self.rulesTableView.backgroundColor = UIColor(displayP3Red: (25/255), green: (118/255), blue: (210/255), alpha: 0)
        // Do any additional setup after loading the view.
    }
    
    class func newInstance(rules: [Rule]) -> RulesViewController {
        let rlvc = RulesViewController()
        rlvc.rules = rules
        return rlvc
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.rules.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell", for: indexPath) as! RuleTableViewCell
        let rule = self.rules[indexPath.section]
        authorWebService.getAuthor(id: rule.author, completion: { author in
            if !author.isEmpty {
                cell.authorLabel.text = author[0].name
            }
        })
        categoryWebService.getCategory(id: rule.category, completion: { category in
            if !category.isEmpty {
                cell.categoryLabel.text = category[0].name
            }
        })
        cell.nameLabel.text = rule.name
        cell.contentLabel.text = rule.content
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let spacing: CGFloat = 5
        return spacing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rule = self.rules[indexPath.section]
        //let ruleDetails = RuleDetailsViewController.newInstance(rule: rule)
        //self.navigationController?.pushViewController(ruleDetails, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sortRulesByName()
        if UIApplication.shared.statusBarOrientation.isLandscape {
            let portrait = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portrait, forKey: "orientation")
        }
        
        sortRulesByName()
    }
    
    func sortRulesByName(){
        self.rules.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        self.rulesTableView.reloadData()
    }
    
    func sortRulesByCategoryName(){
        self.rules.sort(by: { $0.category.description.lowercased() < $1.category.description.lowercased() })
        self.rulesTableView.reloadData()
    }
    
    func sortRuleByRate(){
        self.rules.sort(by: { $0.rate < $1.rate })
        self.rulesTableView.reloadData()
    }
    
    func sortRulesByDrinks(){
        self.rules.sort(by: { $0.drinks < $1.drinks })
        self.rulesTableView.reloadData()
    }

}
