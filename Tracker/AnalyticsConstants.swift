//
//  AnalyticsConstants.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 10.08.2025.
//

import Foundation

enum AnalyticsConstants {
    // API Keys
    static let appMetricaApiKey = "acb8901a-d68c-4fe5-bb46-f01839cc45be"
    
    // Event Types
    enum EventType {
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }
    
    // Parameter Keys
    enum ParameterKey {
        static let event = "event"
        static let screen = "screen"
        static let item = "item"
    }
    
    // Event Names
    static let analyticsEventName = "analytics_event"
}
