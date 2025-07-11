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
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()
    
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Ошибка сохранения: \(nserror)")
            }
        }
    }
    
    // MARK: - App Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        WeekDayValueTransformer.register()
        UIColorValueTransformer.register()
        checkCoreDataInitialization()
        
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
    
      func applicationDidEnterBackground(_ application: UIApplication) {
          saveContext()
      }
      
      func applicationWillTerminate(_ application: UIApplication) {
          saveContext()
      }
    
    func checkCoreDataInitialization() {
        let container = persistentContainer
        print("Core Data контейнер загружен успешно")
        print("Имя модели: \(container.name)")
        print("Количество хранилищ: \(container.persistentStoreDescriptions.count)")
        
        let context = container.viewContext
        print("Контекст доступен: \(context)")
        
        do {
            let count = try context.count(for: TrackerCoreData.fetchRequest())
            print("Количество трекеров в базе: \(count)")
        } catch {
            print("Ошибка при проверке Core Data: \(error)")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

// MARK: - Shared Context Access
extension AppDelegate {
    static var viewContext: NSManagedObjectContext {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить доступ к AppDelegate")
        }
        return delegate.persistentContainer.viewContext
    }
}
