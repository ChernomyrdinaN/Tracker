//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 02.08.2025.
//

import Foundation
import AppMetricaCore

protocol AnalyticsServiceProtocol {
    func trackEvent(_ event: String, screen: String, item: String?)
    func trackScreenOpen(_ screen: String)
    func trackScreenClose(_ screen: String)
    func trackButtonClick(_ screen: String, item: String)
}

final class AnalyticsService: AnalyticsServiceProtocol {
    
    static let shared = AnalyticsService()
    
    private init() {
        setup()
    }
    
    private func setup() {
        guard let configuration = AppMetricaConfiguration(apiKey: "acb8901a-d68c-4fe5-bb46-f01839cc45be") else {
            print("Ошибка: неверный API-ключ AppMetrica")
            return
        }
        
        AppMetrica.activate(with: configuration)
        print("AppMetrica активирована с ключом: \(configuration.apiKey)")
    }

    func trackEvent(_ event: String, screen: String, item: String?) {
        var params: [String: Any] = [
            "event": event,
            "screen": screen
        ]
        
        if let item = item {
            params["item"] = item
        }
        
        print("Отправка события: \(params)")
        AppMetrica
            .reportEvent(name: "analytics_event", parameters: params) {_ in 
            print("✅ Событие отправлено: \(params)")
        }
    }
    
    func trackScreenOpen(_ screen: String) {
        trackEvent("open", screen: screen, item: nil)
    }
    
    func trackScreenClose(_ screen: String) {
        trackEvent("close", screen: screen, item: nil)
    }
    
    func trackButtonClick(_ screen: String, item: String) {
        trackEvent("click", screen: screen, item: item)
    }
}
