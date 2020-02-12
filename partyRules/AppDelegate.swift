//
//  AppDelegate.swift
//  partyRules
//
//  Created by Julien Guillan on 05/01/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController =  UINavigationController(rootViewController: GalleryViewController())
        w.makeKeyAndVisible()
        self.window = w
        return true
    }
}
