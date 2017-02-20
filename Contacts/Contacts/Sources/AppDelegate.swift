//
//  AppDelegate.swift
//  MVVM
//
//  Created by Alexey Bukhtin on 10/02/2017.
//  Copyright © 2017 FocusCura. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = UIColor(white: 0.98, alpha: 1)
        injectRootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    private func injectRootViewController() {
        let contactsViewController = ContactsViewController()
        let navigationController = UINavigationController(rootViewController: contactsViewController)
        let contactsRouter = ContactsRouter(navigationController: navigationController)
        let contactsDataSource = ContactsDataSource()

        contactsViewController.contactsPresenter = ConstactsPresenter(contactsRouter: contactsRouter,
                                                                      contactsDataSource: contactsDataSource,
                                                                      contactsViewController: contactsViewController)

        window?.rootViewController = navigationController
    }
}
