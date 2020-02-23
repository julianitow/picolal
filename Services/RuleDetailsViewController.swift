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
    var voted:Bool = false
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var drinksLabel: UILabel!
    @IBOutlet var drinksStackView: UIStackView!
    @IBOutlet var rateStackView: UIStackView!
    @IBOutlet var nextButton: UIButton!
    
    let ruleWebService: RuleWebService = RuleWebService()
    let authorWebService: AuthorWebService = AuthorWebService()
    let rateWebService: RateWebService = RateWebService()

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotateLandscape()
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
        self.voted = false
        self.rule = rule
        self.nameLabel.text = rule.name
        self.contentLabel.text = self.breakString(string: rule.content)
        self.playerLabel.text = player
        self.drinksLabel.text = String(rule.drinks)
        authorWebService.getAuthor(id: rule.author, completion: { author in
            if !author.isEmpty {
                self.authorLabel.text = author[0].name
            }
        })
        let starBackground = UIColor(red: 253.0/255, green: 216.0/255, blue: 53.0/255, alpha: 255.0/255)
        let stars = getAllStars(fromView: self.rateStackView)
        
        for nbBtn in 0..<stars.count {
            if nbBtn < rule.rate {
                stars[nbBtn].tintColor = starBackground
            }
            stars[nbBtn].tag = nbBtn
            stars[nbBtn].addTarget(self, action: #selector(rateAction), for: .touchUpInside)
        }
    }
    
    func getAllStars(fromView view: UIStackView)-> [UIButton] {
        return view.arrangedSubviews.compactMap { (view) -> [UIButton]? in
            if view is UIButton {
                //view.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 255.0)
                view.tintColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 255.0)
                return [(view as! UIButton)]
            } else {
                return getAllStars(fromView: view as! UIStackView)
            }
        }.flatMap({$0})
    }
    
    @objc func rateAction(sender: UIButton!){
        if !self.voted{
            let rate = Rate(rate: sender.tag + 1, rule: self.rule.id!)
            self.rateWebService.createRate(rate: rate, completion: {(result) in
                if result {
                    self.ruleWebService.getRuleById(id: 1, completion: {(rule) in
                        //print(rule)
                    })
                }
            })
            self.alert(title: "Thank you !", message: "Thank you for your participation ! :)", action: "You're welcome.")
            self.voted = true
        } else {
            self.alert(title: "Thank you !", message: "But you can only vote one time per game ;)", action: "I understand.")
        }
    }
    
    func alert(title: String, message: String, action: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func randomNumber(min: Int, max: Int) -> Int{
        if(max > 0){
            return Int.random(in: min ..< max)
        }
        return 0
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
            self.nextButton.removeFromSuperview()
            self.authorLabel.text = ""
            self.nameLabel.text = ""
            self.contentLabel.text = ""
            self.nameLabel.text = ""
            self.drinksStackView.removeFromSuperview()
            self.rateStackView.removeFromSuperview()
            self.playerLabel.text = "Finished"
        }
    }

    @IBAction func quitAction(_ sender: Any) {
        if(self.playerLabel.text == "Finished"){
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Already drunk ?", message: "Are you sure you want to leave ? ", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
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
    
    func rotateLandscape(){
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
        
        if statusBarOrientation!.isPortrait{
            let landscape = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(landscape, forKey: "orientation")
        }
    }
}
