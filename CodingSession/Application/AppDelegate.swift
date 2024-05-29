//
//  AppDelegate.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureWindow()
        return true
    }
    
    private func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = VideoPreviewsGridConfigurator.makeViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}

