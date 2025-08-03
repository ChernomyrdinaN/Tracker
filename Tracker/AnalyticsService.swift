//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 02.08.2025.
//
//

import Foundation
import AppMetricaCore

final class AnalyticsService {
    
    // MARK: - Constants
    private enum EventType {
        static let open = "open"
        static let close = "close"
        static let click = "click"
    }
    
    private enum ParameterKey {
        static let event = "event"
        static let screen = "screen"
        static let item = "item"
    }
    
    // MARK: - Properties
    static let shared = AnalyticsService()
    
    // MARK: - Init
    private init() {
        setup()
    }
    
    // MARK: - Configuration
    private func setup() {
        guard let configuration = AppMetricaConfiguration(apiKey: "acb8901a-d68c-4fe5-bb46-f01839cc45be") else {
            print("Ошибка: неверный API-ключ AppMetrica")
            return
        }
        
        AppMetrica.activate(with: configuration)
        print("AppMetrica успешно активирована с ключом: \(configuration.apiKey)")
    }
    
    // MARK: - Public Methods
    func trackEvent(_ event: String, screen: String, item: String? = nil) {
        DispatchQueue.main.async {
            var params: [String: Any] = [
                ParameterKey.event: event,
                ParameterKey.screen: screen
            ]
            
            if let item = item {
                params[ParameterKey.item] = item
            }
            
            print("[Analytics] Отправка события: \(params)")
            
            AppMetrica.reportEvent(name: "analytics_event", parameters: params) { (error: Error?) in
                if let error = error {
                    print("[Analytics] Ошибка отправки события: \(error.localizedDescription)")
                } else {
                    print("[Analytics] Событие успешно отправлено: \(params)")
                }
            }
        }
    }
    
    func trackScreenOpen(_ screen: String) {
        trackEvent(EventType.open, screen: screen)
    }
    
    func trackScreenClose(_ screen: String) {
        trackEvent(EventType.close, screen: screen)
    }
    
    func trackButtonClick(_ screen: String, item: String) {
        trackEvent(EventType.click, screen: screen, item: item)
    }
}
