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
    func testTrackersViewControllerLightTheme() {
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        
        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13), // Для iPhone 16 Pro (используем ближайший аналог — iPhone13)
            timeout: 5.0
        )
    }
}
