//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    
    // MARK: - Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    // MARK: - Initialization
    override init() {
        self.context = AppDelegate.viewContext
        super.init()
        setupFetchedResultsController()
    }
    
    // MARK: - Setup
    private func setupFetchedResultsController() {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Не удалось инициализировать FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - Public Methods
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
        request.fetchLimit = 1
        
        if let existing = try? context.fetch(request).first {
            context.delete(existing)
        } else {
            let newRecord = TrackerRecordCoreData(context: context)
            newRecord.trackerId = trackerId
            newRecord.date = date
        }
        saveContext()
    }
    
    func deleteAllRecords(for trackerId: UUID) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@", trackerId as CVarArg)
        
        if let records = try? context.fetch(request) {
            records.forEach { context.delete($0) }
            saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
