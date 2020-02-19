//
//  PlayersViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 19/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    class func newInstance() -> PlayersViewController{
        let pvc = PlayersViewController()
        
        return pvc
    }

    @IBAction func playAction(_ sender: Any) {
        let textFields = getAllTextFields(fromView: self.view)
        var players: [String] = []
        textFields.forEach({ (textField) in
            players.append(textField.text!)
        })
        let rdvc = RuleDetailsViewController.newInstance(players: players)
        navigationController?.pushViewController(rdvc, animated: true)
    }
    
    func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.compactMap { (view) -> [UITextField]? in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.flatMap({$0})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
