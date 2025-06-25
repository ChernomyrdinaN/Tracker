//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.06.2025.
//  Модель сохранения прогресса трекера на определенную дату (для хранения записи о том, что некий трекер был выполнен на некоторую дату)

import Foundation

struct TrackerRecord: Codable {
    let trackerId: UUID
    let date: Date
}
