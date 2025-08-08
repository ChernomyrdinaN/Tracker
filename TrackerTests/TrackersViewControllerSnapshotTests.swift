//
//  TrackersViewControllerSnapshotTests.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 01.08.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    
    func testLightTheme() {
        let vc = TrackersViewController()
        vc.overrideUserInterfaceStyle = .light
        vc.loadViewIfNeeded()
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13), // Для iPhone 16 Pro (используем ближайший аналог — iPhone13)
            named: "LightTheme"
        )
    }
    
    func testDarkTheme() {
        let vc = TrackersViewController()
        vc.overrideUserInterfaceStyle = .dark
        vc.loadViewIfNeeded()
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13),
            named: "DarkTheme"
        )
    }
}
