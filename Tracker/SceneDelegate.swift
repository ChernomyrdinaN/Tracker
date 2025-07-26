//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")
        
        if isOnboardingCompleted {
            
            window?.rootViewController = TrackerTabBarController()
        } else {
            
            let onboardingVC = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            window?.rootViewController = onboardingVC
        }
        
        window?.makeKeyAndVisible()
    }
}
