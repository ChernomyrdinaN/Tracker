//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 07.07.2025.
//

import CoreData
import UIKit

final class TrackerStore: TrackerStoreProtocol  { // Класс-прослойка между Core Data и приложением
    // MARK: - Properties
    private let context: NSManagedObjectContext // Получаем контекст из AppDelegate через инициализатор
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func addTracker(_ tracker: Tracker) { // Добавляем трекер в Core Data
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id // Заполняем свойства
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorAssetName = tracker.colorAssetName
        
        let scheduleData = try? NSKeyedArchiver.archivedData( // Преобразуем расписание в Data в бинарные данные
            withRootObject: tracker.schedule.map { $0.rawValue },
            requiringSecureCoding: false
        )
        trackerEntity.schedule = scheduleData
        
        do {
            try context.save() // Сохраняем контекст, изменения
            print("Трекер успешно сохранен: \(trackerEntity)")
        } catch {
            print("Ошибка сохранения трекера: \(error)")
        }
    }
    
    func fetchTrackers() -> [Tracker] { // Получаем все трекеры из Core Data
        let request = TrackerCoreData.fetchRequest()
        
        do {
            let coreDataTrackers = try context.fetch(request)
            return coreDataTrackers.compactMap { createTracker(from: $0) }
        } catch {
            print("Ошибка загрузки трекера: \(error)")
            return []
        }
    }
    
    func deleteTracker(id: UUID) { // Удаляем запись по ID трекера и дате
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let tracker = try context.fetch(request).first {
                context.delete(tracker)
                try context.save()
                print("Трекер успешно удалён")
            }
        } catch {
            print("Ошибка удаления трекера: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Methods
    private func createTracker(from coreData: TrackerCoreData) -> Tracker? { // Преобразуем сущность Core Data в доменную модель Tracker
        guard let id = coreData.id,
              let name = coreData.name,
              let color = coreData.color,
              let emoji = coreData.emoji else {
            return nil
        }
        
        let schedule: [WeekDay] = {
            guard let data = coreData.schedule, // Декодируем данные расписания
                  let strings = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: data) as? [String] else {
                return []
            }
            return strings.compactMap { WeekDay(rawValue: $0) }
        }()
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            colorAssetName: coreData.colorAssetName ?? ""
        )
    }
}
