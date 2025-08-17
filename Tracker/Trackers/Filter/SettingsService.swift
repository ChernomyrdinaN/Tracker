//
//  SettingsService.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 05.08.2025.
//

import Foundation

protocol SettingsServiceProtocol {
    func saveCurrentFilter(_ filter: FilterType)
    func loadCurrentFilter() -> FilterType
}

final class SettingsService: SettingsServiceProtocol {
    private enum Keys {
        static let currentFilter = "currentFilter"
    }
    
    func saveCurrentFilter(_ filter: FilterType) {
        UserDefaults.standard.set(filter.rawValue, forKey: Keys.currentFilter)
    }
    
    func loadCurrentFilter() -> FilterType {
        let rawValue = UserDefaults.standard.integer(forKey: Keys.currentFilter)
        return FilterType(rawValue: rawValue) ?? .all
    }
}
