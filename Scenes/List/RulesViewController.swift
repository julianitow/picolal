//
//  RulesViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 26/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let ruleWebService: RuleWebService = RuleWebService()
    let categoryWebService: CategoryWebService = CategoryWebService()
    let authorWebService: AuthorWebService = AuthorWebService()
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
        authorWebService.getAuthorById(id:rule.author.id!, completion: { author in
            if author.id == nil {
                cell.authorLabel.text = "Unknown"
            }
        })
        categoryWebService.getCategoryById(id: rule.category.id!, completion: { category in
            if category.id == nil {
                cell.categoryLabel.text = "Unknown"
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
        let ruleDetails = RuleDetailsViewController.newInstance(rule: rule)
        self.navigationController?.pushViewController(ruleDetails, animated: true)
    }

}
