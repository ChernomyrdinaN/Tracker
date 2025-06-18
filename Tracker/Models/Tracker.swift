//
//  Tracker.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.06.2025.
//  Модель для создания и хранения трекеров (привычек)

import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [WeekDay]? // nil для нерегулярных событий
    let isRegular: Bool // true для привычки, false для нерегулярного события
}

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
}
