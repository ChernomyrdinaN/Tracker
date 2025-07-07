//
//  AppDelegate.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data load error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Core Data Saving
        func saveContext() {
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Core Data save error: \(error.localizedDescription)")
                    context.rollback()
                }
            }
        }
    
    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = persistentContainer
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = Colors.white
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        UITabBar.appearance().isTranslucent = false
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - Простой доступ к контексту
extension AppDelegate {
    static var viewContext: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
