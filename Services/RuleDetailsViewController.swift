//
//  RuleDetailsViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 06/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RuleDetailsViewController: UIViewController {

    var rule: Rule!
    var rules: [Rule]!
    var players: [String]!
    var category: String!
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var playerLabel: UILabel!
    
    let ruleWebService: RuleWebService = RuleWebService()
    let authorWebService: AuthorWebService = AuthorWebService()
    let categoryWebService: CategoryWebService = CategoryWebService()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if UIApplication.shared.statusBarOrientation.isPortrait {
            let landscape = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(landscape, forKey: "orientation")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRules()
        /**/
        //ruleDetailsViewController.rule = rule
        // Force landscape mode
        let landscapeLeftValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeLeftValue, forKey: "orientation")
    }
    
    class func newInstance(players: [String], category: String) -> RuleDetailsViewController{
        let rdvc = RuleDetailsViewController()
        rdvc.players = players
        rdvc.category = category
        return rdvc
    }
    
    func getRules(){
        self.ruleWebService.getRulesByCategory(categoryName: self.category, completion: { (rules) in
            self.rules = rules
            let index = self.randomNumber(min: 0, max: rules.count)
            let indexPlayer = self.randomNumber(min: 0, max: self.players.count)
            self.display(rule: self.rules[index], player: self.players[indexPlayer])
            self.rules.remove(at: index)
        })
    }
    
    func display(rule: Rule, player: String){
        self.nameLabel.text = rule.name
        self.contentLabel.text = self.breakString(string: rule.content)
        self.playerLabel.text = player
        authorWebService.getAuthor(id: rule.author, completion: { author in
            if !author.isEmpty {
                self.authorLabel.text = author[0].name
            }
        })
        categoryWebService.getCategory(id: rule.category, completion: { category in
            if !category.isEmpty {
                self.categoryLabel.text = category[0].name
            }
        })
    }
    
    func randomNumber(min: Int, max: Int) -> Int{
        return Int.random(in: min ..< max)
    }
    
    @IBAction func nextRuleAction(_ sender: Any) {
        if(self.rules.count > 0){
            let indexRule = randomNumber(min: 0, max: self.rules.count)
            let indexPlayer = randomNumber(min: 0, max: self.players.count)
            let player = self.players[indexPlayer]
            let rule = self.rules[indexRule]
            self.rules.remove(at: indexRule)
            display(rule: rule, player: player)
        }
        else if self.playerLabel.text == "Finished" {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.categoryLabel.text = ""
            self.authorLabel.text = ""
            self.nameLabel.text = ""
            self.contentLabel.text = ""
            self.nameLabel.text = ""
            self.playerLabel.text = "Finished"
        }
    }

    @IBAction func quitAction(_ sender: Any) {
        let alert = UIAlertController(title: "Already drunk ?", message: "Are you sure you want to leave ? ", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    func breakString(string: String) -> String{
        var result = string
        if(string.count > 80){
            var offset = 50
            var index = string.index(string.startIndex, offsetBy: offset)
            while(string[index] != " "){
                offset+=1
                index = string.index(string.startIndex, offsetBy: offset)
            }
            result.insert("\n", at: index)
        }
        return result
    }
}
