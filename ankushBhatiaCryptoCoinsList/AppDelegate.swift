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
        let viewModel = ViewModelFactory.makeCryptoListViewModel()
        let navigationController = UINavigationController(rootViewController: CryptoListViewController(viewModel: viewModel))
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .purple
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.standardAppearance = navBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance;
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}

