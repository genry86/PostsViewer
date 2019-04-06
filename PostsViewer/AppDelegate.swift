//
//  AppDelegate.swift
//  PostsViewer
//
//  Created by Genry on 3/18/19.
//  Copyright © 2019 Genry. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var appStartService: AppStartupServiceProtocol? = {
        return ServiceFactory.resolve(AppStartupServiceProtocol.self)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        self.window = window

        ServiceFactory.registerAll()
        appStartService?.start() {
            APPLogger.info { "App did finish launching" }
        }

        window.rootViewController = appStartService?.initialController
        return true
    }
}
