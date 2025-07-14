//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 07.07.2025.
//

import CoreData
import UIKit

// MARK: - Protocol
protocol TrackerStoreDelegate: AnyObject {
    func didUpdateTrackers()
}

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private let categoryStore = TrackerCategoryStore()
    
    // MARK: - Init
    override init() {
        self.context = AppDelegate.viewContext
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Public Methods
    func addTracker(_ tracker: Tracker) {
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = UIColor(named: tracker.color)
        trackerEntity.colorAssetName = tracker.color
        trackerEntity.schedule = tracker.schedule as NSObject
        trackerEntity.category = getDefaultCategory()
        saveContext()
    }
    
    func fetchTrackers() -> [Tracker] {
        guard let trackerObjects = fetchedResultsController?.fetchedObjects else { return [] }
        return trackerObjects.compactMap { createTracker(from: $0) }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        if let trackers = try? context.fetch(request) {
            trackers.forEach { context.delete($0) }
            saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func setupFetchedResultsController() {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
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
    
    private func getDefaultCategory() -> TrackerCategoryCoreData {
        return categoryStore.getDefaultCategory()
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

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateTrackers()
    }
}
