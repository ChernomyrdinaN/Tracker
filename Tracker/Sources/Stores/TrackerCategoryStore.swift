//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore {
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    // MARK: - Init
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func fetchAllCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        guard let categories = try? context.fetch(request) else { return [] }
        
        return categories.compactMap { category in
            guard let id = category.id, let title = category.title else { return nil }
            let trackersSet = category.trackers as? Set<TrackerCoreData> ?? []
            let trackers = trackersSet.compactMap { createTracker(from: $0) }
            return TrackerCategory(id: id, title: title, trackers: trackers)
        }
    }
    
    func addCategory(title: String) throws {
        guard !title.isEmpty else {
            throw NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Название категории не может быть пустым"])
        }
        
        guard !categoryExists(title: title) else {
            throw NSError(domain: "Validation", code: 409, userInfo: [NSLocalizedDescriptionKey: "Категория с таким названием уже существует"])
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.id = UUID()
        newCategory.title = title
        saveContext()
    }
    
    func updateCategory(_ category: TrackerCategory, newTitle: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        guard let categoryToUpdate = try? context.fetch(request).first else {
            throw NSError(domain: "Category", code: 404, userInfo: [NSLocalizedDescriptionKey: "Категория не найдена"])
        }
        
        categoryToUpdate.title = newTitle
        
        if let trackers = categoryToUpdate.trackers as? Set<TrackerCoreData> {
            for tracker in trackers {
                tracker.category = categoryToUpdate
            }
        }
        
        saveContext()
    }
    
    func deleteCategory(_ category: TrackerCategory) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        guard let categoryToDelete = try? context.fetch(request).first else {
            throw NSError(domain: "Category", code: 404, userInfo: [NSLocalizedDescriptionKey: "Категория не найдена"])
        }
        
        context.delete(categoryToDelete)
        saveContext()
    }
    
    // MARK: - Private Methods
    private func categoryExists(title: String) -> Bool {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    private func createTracker(from coreData: TrackerCoreData) -> Tracker? {
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
