//
//  Tracker.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.06.2025.
//  Модель для создания и хранения трекеров

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]?
    let isRegular: Bool
    let colorAssetName: String
}

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var calendarIndex: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

// Эти данные используются только для демонстрации работы приложения
struct TrackerDefaults {
    static let defaultEmoji = "👩‍💻"
    static let defaultColor = "Color selection 12"
    static let defaultSchedule: [WeekDay] = [.monday, .wednesday, .friday]
    static let defaultTrackerName = "Позаниматься проектом"
    static let defaultCategoryTitle = "Образование"
}
