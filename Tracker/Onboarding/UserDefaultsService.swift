//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 27.07.2025.
//
import Foundation

final class UserDefaultsService {
    // MARK: - Singleton
    static let shared = UserDefaultsService()
    private init() {}
    
    // MARK: - Dependencies
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
    }
    
    // MARK: - Public Properties
    var isOnboardingCompleted: Bool {
        get { defaults.bool(forKey: Keys.onboardingCompleted) }
        set { defaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    // MARK: - Reset (Optional)
    func resetAll() {
        defaults.removeObject(forKey: Keys.onboardingCompleted)
    }
}
