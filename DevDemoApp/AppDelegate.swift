//
//  AppDelegate.swift
//  DevDemoApp
//
//  Created by Ronald Jones on 8/10/25.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let navigationController = UINavigationController()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        self.window = UIWindow( frame: UIScreen.main.bounds)
        
        let start = StartViewController()
        
        navigationController.viewControllers = [start]
        self.window!.rootViewController = navigationController
        
        self.window!.makeKeyAndVisible()

        return true
    }

   
}

