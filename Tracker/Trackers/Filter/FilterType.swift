//
//  FilterType.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.08.2025.
//

import Foundation

enum FilterType: Int, CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершённые"
        case .uncompleted: return "Незавершённые"
        }
    }
}
