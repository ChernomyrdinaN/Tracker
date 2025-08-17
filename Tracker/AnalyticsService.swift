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
    // MARK: - Properties
    static let shared = AnalyticsService()
    
    // MARK: - Init
    private init() {
        setup()
    }
    
    // MARK: - Configuration
    private func setup() {
        guard let configuration = AppMetricaConfiguration(apiKey: AnalyticsConstants.appMetricaApiKey) else {
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
                AnalyticsConstants.ParameterKey.event: event,
                AnalyticsConstants.ParameterKey.screen: screen
            ]
            
            if let item = item {
                params[AnalyticsConstants.ParameterKey.item] = item
            }
            
            print("[Analytics] Отправка события: \(params)")
            
            AppMetrica.reportEvent(
                name: AnalyticsConstants.analyticsEventName,
                parameters: params
            ) { (error: Error?) in
                if let error {
                    print("[Analytics] Ошибка отправки события: \(error.localizedDescription)")
                } else {
                    print("[Analytics] Событие успешно отправлено: \(params)")
                }
            }
        }
    }
    
    func trackScreenOpen(_ screen: String) {
        trackEvent(AnalyticsConstants.EventType.open, screen: screen)
    }
    
    func trackScreenClose(_ screen: String) {
        trackEvent(AnalyticsConstants.EventType.close, screen: screen)
    }
    
    func trackButtonClick(_ screen: String, item: String) {
        trackEvent(AnalyticsConstants.EventType.click, screen: screen, item: item)
    }
}
