//
//  RuleDetailsViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 06/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class RuleDetailsViewController: UIViewController {

    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    var authorWebService: AuthorWebService = AuthorWebService()
    var categoryWebService: CategoryWebService = CategoryWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func newInstance(rule: Rule){
        self.nameLabel.text = rule.name
        self.contentLabel.text = rule.content
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

}
