//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 07.07.2025.
//

import CoreData
import UIKit

final class TrackerStore { // Класс-прослойка между Core Data и приложением
    
    // MARK: - Properties
    private let context: NSManagedObjectContext // Контекст для работы с базой данных
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext = AppDelegate.viewContext) { // Инициализатор с дефолтным значением контекста
        self.context = context
    }
    
    // MARK: - Core Data Operations
    
    func addTracker(_ tracker: Tracker) throws { //Добавление трекера
        let trackerEntity = TrackerCoreData(context: context) //Создаем новый объект Core Data
        
        trackerEntity.id = tracker.id // Заполняем свойства из модели Tracker
        trackerEntity.name = tracker.name
        trackerEntity.color = tracker.color
        trackerEntity.emoji = tracker.emoji
        trackerEntity.colorAssetName = tracker.colorAssetName
        
        let scheduleStrings = tracker.schedule.map { $0.rawValue }  // Преобразуем [WeekDay] в [String] для сохранения
        trackerEntity.schedule = try? NSKeyedArchiver.archivedData(
            withRootObject: scheduleStrings,
            requiringSecureCoding: false
        )
        
        try context.save() // Пытаемся сохранить контекст
    }
    
    func fetchTrackers() -> [Tracker] { // Получение всех трекеров
        let request = TrackerCoreData.fetchRequest() // Создаем запрос на выборку всех трекеров
        
        do {
            let coreDataTrackers = try context.fetch(request)
            return coreDataTrackers.compactMap { createTracker(from: $0) } // Преобразуем CoreData-объекты в наши модели
        } catch {
            print("Ошибка при загрузке трекеров: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteTracker(id: UUID) throws { // Удаление трекера
        let request = TrackerCoreData.fetchRequest() // Создаем запрос с фильтром по ID
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let tracker = try context.fetch(request).first { // Ищем и удаляем нужный трекер
            context.delete(tracker)
            try context.save() //  Сохраняем изменения
        }
    }
    
    // MARK: - Private Helpers
    
    private func createTracker(from coreData: TrackerCoreData) -> Tracker? { // Преобразуем CoreData-объект в модель Tracker
        guard let id = coreData.id,
              let name = coreData.name,
              let color = coreData.color,
              let emoji = coreData.emoji else {
            return nil
        }
        
        let schedule: [WeekDay] = (coreData.schedule.flatMap { // Преобразуем расписание из CoreData
            try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: $0) as? [String]
        } ?? []).compactMap(WeekDay.init(rawValue:))
        
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
