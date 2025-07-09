//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func addCategory(_ category: TrackerCategory) {
        let categoryEntity = TrackerCategoryCoreData(context: context)
        categoryEntity.id = category.id
        categoryEntity.title = category.title
        
        let trackerEntities = category.trackers.compactMap { tracker -> TrackerCoreData? in
            let trackerEntity = TrackerCoreData(context: context)
            trackerEntity.id = tracker.id
            trackerEntity.name = tracker.name
            trackerEntity.color = tracker.color
            trackerEntity.emoji = tracker.emoji
            trackerEntity.colorAssetName = tracker.colorAssetName
            
            if let scheduleData = try? NSKeyedArchiver.archivedData(
                withRootObject: tracker.schedule.map { $0.rawValue },
                requiringSecureCoding: false
            ) {
                trackerEntity.schedule = scheduleData
            }
            
            return trackerEntity
        }
        
        categoryEntity.trackers = NSSet(array: trackerEntities)
        
        do {
            try context.save()
            print("Категория успешно сохранена: \(categoryEntity)")
        } catch {
            print("Ошибка сохранения категории: \(error.localizedDescription)")
        }
    }
    
    func fetchCategories() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        
        do {
            let coreDataCategories = try context.fetch(request)
            return coreDataCategories.compactMap { createCategory(from: $0) }
        } catch {
            print("Ошибка загрузки категорий: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteCategory(id: UUID) {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let category = try context.fetch(request).first {
                context.delete(category)
                try context.save()
                print("Категория успешно удалена")
            }
        } catch {
            print("Ошибка удаления категории: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    private func createCategory(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let id = coreData.id,
              let title = coreData.title else {
            return nil
        }
        
        let trackers: [Tracker] = {
            guard let trackerEntities = coreData.trackers?.allObjects as? [TrackerCoreData] else {
                return []
            }
            
            return trackerEntities.compactMap { trackerEntity in
                guard let trackerId = trackerEntity.id,
                      let name = trackerEntity.name,
                      let color = trackerEntity.color,
                      let emoji = trackerEntity.emoji else {
                    return nil
                }
                
                let schedule: [WeekDay] = {
                    guard let data = trackerEntity.schedule,
                          let strings = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [String] else {
                        return []
                    }
                    return strings.compactMap { WeekDay(rawValue: $0) }
                }()
                
                return Tracker(
                    id: trackerId,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: schedule,
                    colorAssetName: trackerEntity.colorAssetName ?? ""
                )
            }
        }()
        
        return TrackerCategory(
            id: id,
            title: title,
            trackers: trackers
        )
    }
}
