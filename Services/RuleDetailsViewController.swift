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
    
    class func newInstance(players: [String]) -> RuleDetailsViewController{
        let rdvc = RuleDetailsViewController()
        rdvc.players = players
        return rdvc
    }
    
    func getRules(){
        self.ruleWebService.getRules { (rules) in
            self.rules = rules
            let index = self.randomNumber(min: 0, max: rules.count)
            let indexPlayer = self.randomNumber(min: 0, max: self.players.count)
            self.display(rule: self.rules[index], player: self.players[indexPlayer])
            self.rules.remove(at: index)
        }
    }
    
    func display(rule: Rule, player: String){
        self.nameLabel.text = rule.name
        self.contentLabel.text = rule.content
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
        } else {
            self.contentLabel.text = "Finished"
        }
    }
    
    func instanciateData(){
        print(self.rules)
    }

}
