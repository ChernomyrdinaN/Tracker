//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func addRecord(_ record: TrackerRecord) {
        let recordEntity = TrackerRecordCoreData(context: context)
        recordEntity.trackerId = record.trackerId
        recordEntity.date = record.date
        
        do {
            try context.save()
            print("Запись успешно сохранена: \(recordEntity)")
        } catch {
            print("Ошибка сохранения записи: \(error)")
        }
    }
    
    func fetchRecords() -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        
        do {
            let coreDataRecords = try context.fetch(request)
            return coreDataRecords.compactMap { createRecord(from: $0) }
        } catch {
            print("Ошибка загрузки записей: \(error)")
            return []
        }
    }
    
    func deleteRecord(trackerId: UUID, date: Date) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date BETWEEN {%@, %@}",
            trackerId as CVarArg,
            date.startOfDay as CVarArg,
            date.endOfDay as CVarArg
        )
        
        do {
            let records = try context.fetch(request)
            records.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("Ошибка удаления записей: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    private func createRecord(from coreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard let trackerId = coreData.trackerId,
              let date = coreData.date else {
            return nil
        }
        
        return TrackerRecord(
            trackerId: trackerId,
            date: date
        )
    }
}

// Вспомогательные расширения для работы с датами
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: startOfDay) ?? startOfDay
    }
}
