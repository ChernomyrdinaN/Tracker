//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

// MARK: - Protocol
protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdateRecords()
}

final class TrackerRecordStore: NSObject {
    // MARK: - Properties
    weak var delegate: TrackerRecordStoreDelegate?
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    // MARK: - Init
    override init() {
        self.context = AppDelegate.viewContext
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Public Methods
    func addRecord(_ record: TrackerRecord) {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.trackerId = record.trackerId
        recordEntity.date = record.date
        saveContext()
    }
    
    func fetchRecords() -> [TrackerRecord] {
        guard let objects = fetchedResultsController?.fetchedObjects else { return [] }
        return objects.compactMap { record in
            guard let trackerId = record.trackerId, let date = record.date else { return nil }
            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }
    
    func toggleRecord(for trackerId: UUID, date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            startOfDay as CVarArg,
            endOfDay as CVarArg
        )
        
        if let existing = try? context.fetch(request).first {
            context.delete(existing)
        } else {
            addRecord(TrackerRecord(trackerId: trackerId, date: date))
        }
        saveContext()
    }
    
    // MARK: - Private Methods
    private func setupFetchedResultsController() {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
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
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Не удалось сохранить контекст: \(error)")
            context.rollback()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateRecords()
    }
}
