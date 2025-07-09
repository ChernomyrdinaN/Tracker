//
//  TrackerCategoryStoreProtocol.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 09.07.2025.
//

import Foundation

protocol TrackerCategoryStoreProtocol {
    func addCategory(_ tracker: TrackerCategory)
    func fetchCategories() -> [TrackerCategory]
    func deleteCategory(id: UUID)
}
