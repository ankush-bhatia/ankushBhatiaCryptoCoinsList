//
//  AppDelegate.swift
//  ankushBhatiaCryptoCoinsList
//
//  Created by ANKUSH BHATIA on 1/20/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let viewModel = CryptoListViewModel()
        let navigationController = UINavigationController(rootViewController: CryptoListViewController(viewModel: viewModel))
        navigationController.view.backgroundColor = .white
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = false
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}

