//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
    }
    
    func addCategory(_ category: TrackerCategory) {
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.id = category.id
        categoryEntity.title = category.title
        saveContext()
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        guard let coreDataCategories = try? context.fetch(request) else {
            return []
        }
        
        return coreDataCategories.compactMap { coreData in
            guard let id = coreData.id,
                  let title = coreData.title else {
                return nil
            }
            
            let trackers = (coreData.trackers?.allObjects as? [TrackerCoreData])?
                .compactMap { TrackerStore(context: context).createTracker(from: $0) } ?? []
            
            return TrackerCategory(
                id: id,
                title: title,
                trackers: trackers
            )
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
