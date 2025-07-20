//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.06.2025.
//  Модель для хранения прогресса трекера на определенную дату 

import Foundation

struct TrackerRecord: Codable {
    let trackerId: UUID
    let date: Date
}
