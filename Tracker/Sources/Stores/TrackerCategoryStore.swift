//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func setupDefaultCategory() {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Все")
        
        if let count = try? context.count(for: request), count == 0 {
            let defaultCategory = TrackerCategoryCoreData(context: context)
            defaultCategory.id = UUID()
            defaultCategory.title = "Все"
            saveContext()
        }
    }
    
    func fetchDefaultCategoryWithTrackers() -> TrackerCategory? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", "Все")
        
        guard let categoryCoreData = try? context.fetch(request).first,
              let id = categoryCoreData.id,
              let title = categoryCoreData.title else {
            return nil
        }
        
        let trackersSet = categoryCoreData.trackers as? Set<TrackerCoreData> ?? []
        
        let trackers: [Tracker] = trackersSet.compactMap { coreDataTracker in
            guard let trackerId = coreDataTracker.id,
                  let name = coreDataTracker.name,
                  let emoji = coreDataTracker.emoji,
                  let color = coreDataTracker.color as? UIColor,
                  let schedule = coreDataTracker.schedule as? [WeekDay] else {
                return nil
            }
            
            return Tracker(
                id: trackerId,
                name: name,
                color: color.accessibilityName,
                emoji: emoji,
                schedule: schedule,
                colorAssetName: coreDataTracker.colorAssetName ?? ""
            )
        }
        
        return TrackerCategory(
            id: id,
            title: title,
            trackers: trackers
        )
    }
    
    // MARK: - Private Methods
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
