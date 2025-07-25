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
        
        // Создаём окно
        window = UIWindow(windowScene: windowScene)
        
        // Проверяем, проходил ли пользователь онбординг
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")
        
        // Выбираем корневой контроллер
        if isOnboardingCompleted {
            // Если онбординг пройден - показываем основной интерфейс
            window?.rootViewController = TrackerTabBarController()
        } else {
            // Если не пройден - показываем онбординг
            let onboardingVC = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            window?.rootViewController = onboardingVC
        }
        
        window?.makeKeyAndVisible()
    }
}
