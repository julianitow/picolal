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
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    var authorWebService: AuthorWebService = AuthorWebService()
    var categoryWebService: CategoryWebService = CategoryWebService()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = rule.name
        self.contentLabel.text = rule.content
        authorWebService.getAuthorById(id: rule.author.id!, completion: { author in
            if author.id == nil {
                self.authorLabel.text = "Unknown"
            }
        })
        categoryWebService.getCategoryById(id: rule.category.id!, completion: { category in
            if category.id == nil {
                self.categoryLabel.text = "Unknown"
            }
        })
        // Force landscape mode
        let landscapeLeftValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeLeftValue, forKey: "orientation")
    }
    
    class func newInstance(rule: Rule) -> RuleDetailsViewController{
        let ruleDetailsViewController = RuleDetailsViewController()
        ruleDetailsViewController.rule = rule
        return ruleDetailsViewController
    }

}
