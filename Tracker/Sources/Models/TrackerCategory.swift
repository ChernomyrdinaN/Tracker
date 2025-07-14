//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.06.2025.
//  Модель для хранения трекеров по категориям

import Foundation

struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
}
