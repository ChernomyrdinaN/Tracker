//
//  TrackerStoreProtocol.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//
import Foundation

protocol TrackerStoreProtocol {
    func addTracker(_ tracker: Tracker)
    func fetchTrackers() -> [Tracker]
    func deleteTracker(id: UUID)
}
