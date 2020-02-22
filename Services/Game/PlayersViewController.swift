//
//  PlayersViewController.swift
//  partyRules
//
//  Created by Julien Guillan on 19/02/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    
    let categoryWebService = CategoryWebService()
    var categories: [Category]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        getCategories()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        rotatePortrait()
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
        //let rdvc = RuleDetailsViewController.newInstance(players: players)
        let csvc = CategorySelectionViewController.newInstance(players: players, categories: self.categories)
        
        navigationController?.pushViewController(csvc, animated: true)
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
    
    func getCategories(){
        self.categoryWebService.getAllCategories(completion: {(categories) in
            self.categories = categories
            print(categories)
        })
        
    }
    

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
