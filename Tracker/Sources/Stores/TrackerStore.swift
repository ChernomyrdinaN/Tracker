//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 07.07.2025.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    // MARK: - Init
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Public Methods
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        guard !tracker.name.isEmpty else {
            throw NSError(domain: "Validation", code: 400, userInfo: [NSLocalizedDescriptionKey: "Название трекера не может быть пустым"])
        }
        
        guard !trackerExists(name: tracker.name, in: category) else {
            throw NSError(domain: "Validation", code: 409, userInfo: [NSLocalizedDescriptionKey: "Трекер с таким названием уже существует в этой категории"])
        }
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = UIColor(named: tracker.color)
        trackerEntity.colorAssetName = tracker.color
        trackerEntity.schedule = tracker.schedule as NSObject
        
        let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
        
        if let categoryEntity = try? context.fetch(categoryRequest).first {
            trackerEntity.category = categoryEntity
        }
        
        saveContext()
    }
    
    func fetchTrackers() -> [Tracker] {
        guard let trackerObjects = fetchedResultsController?.fetchedObjects else { return [] }
        return trackerObjects.compactMap { createTracker(from: $0) }
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let trackerToDelete = try? context.fetch(request).first else {
            throw NSError(domain: "Tracker", code: 404, userInfo: [NSLocalizedDescriptionKey: "Трекер не найден"])
        }
        
        context.delete(trackerToDelete)
        saveContext()
    }
    
    // MARK: - Private Methods
    private func setupFetchedResultsController() {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Не удалось инициализировать FetchedResultsController: \(error)")
        }
    }
    
    private func trackerExists(name: String, in category: TrackerCategory) -> Bool {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "name == %@ AND category.id == %@",
            name,
            category.id as CVarArg
        )
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
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            print("Не удалось сохранить контекст: \(error)")
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
