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
    var ruleWebService: RuleWebService = RuleWebService()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        sortRulesByName()
        rotatePortrait()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        cell.drinksLabel.text = String(rule.drinks)
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
        let alert = UIAlertController(title: "Delete ?", message: "Are you sure ? This is irreversible.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            let indexPath_tmp = IndexPath(item: 0, section: indexPath.section)
            //self.rulesTableView.deleteRows(at: [indexPath_tmp], with: .fade)
            self.ruleWebService.deleteRule(ruleId: rule.id!, completion: { rule in
                //self.rules.remove(at: indexPath.section)
            })
        }))
        self.present(alert, animated: true)
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
