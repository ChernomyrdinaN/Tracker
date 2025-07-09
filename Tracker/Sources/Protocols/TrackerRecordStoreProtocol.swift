//
//  TrackerRecordStoreProtocol.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import Foundation

protocol TrackerRecordStoreProtocol {
    func addRecord(_ tracker: TrackerRecord)
    func fetchRecords() -> [TrackerRecord]
    func deleteRecord(trackerId: UUID, date: Date)
}
