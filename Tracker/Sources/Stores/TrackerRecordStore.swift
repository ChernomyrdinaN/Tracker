//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = AppDelegate.viewContext) {
        self.context = context
    }
    
    func fetchRecords() -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        
        guard let coreDataRecords = try? context.fetch(request) else {
            return []
        }
        
        return coreDataRecords.compactMap { coreData in
            guard let trackerId = coreData.trackerId,
                  let date = coreData.date else {
                return nil
            }
            return TrackerRecord(trackerId: trackerId, date: date)
        }
    }
    
    func toggleRecord(for trackerId: UUID, date: Date) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date BETWEEN {%@, %@}",
            trackerId as CVarArg,
            date.startOfDay as CVarArg,
            date.endOfDay as CVarArg
        )
        
        if let existing = try? context.fetch(request).first {
            context.delete(existing)
        } else {
            let newRecord = TrackerRecordCoreData(context: context)
            newRecord.trackerId = trackerId
            newRecord.date = date
        }
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) ?? self
    }
}
