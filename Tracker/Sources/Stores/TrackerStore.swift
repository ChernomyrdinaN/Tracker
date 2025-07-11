//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 07.07.2025.
//

import CoreData
import UIKit

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
    }
    
    func addTracker(_ tracker: Tracker) {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = UIColor(named: tracker.color)
        trackerEntity.colorAssetName = tracker.color
        trackerEntity.schedule = tracker.schedule as NSObject
        
        let defaultCategory = getDefaultCategory()
        trackerEntity.category = defaultCategory
        
        saveContext()
    }
    
    private func getDefaultCategory() -> TrackerCategoryCoreData {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Образование")
        
        if let existing = try? context.fetch(request).first {
            return existing
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.id = UUID()
        newCategory.title = "Образование"
        return newCategory
    }
    
    func createTracker(from coreData: TrackerCoreData) -> Tracker? {
        guard let id = coreData.id,
              let name = coreData.name,
              let emoji = coreData.emoji,
              let color = coreData.color as? UIColor,
              let schedule = coreData.schedule as? [WeekDay] else {
            return nil
        }
        
        return Tracker(
            id: id,
            name: name,
            color: color.accessibilityName,
            emoji: emoji,
            schedule: schedule,
            colorAssetName: coreData.colorAssetName ?? ""
        )
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
