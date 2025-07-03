//
//  TrackerTabBarController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 16.06.2025.
//

import UIKit

final class TrackerTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    // MARK: - Setup
    private func setupTabs() {
        
        let trackersVC = TrackersViewController()
        let trackersNavVC = UINavigationController(rootViewController: trackersVC)
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersIcon),
            selectedImage: nil
        )
        
        let statisticsVC = StatisticsViewController()
        let statisticsNavVC = UINavigationController(rootViewController: statisticsVC)
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticsIcon),
            selectedImage: nil
        )
        
        viewControllers = [trackersNavVC, statisticsNavVC]
    }
    
    private func setupAppearance() {
        guard tabBar.viewWithTag(999) == nil else { return }
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1))
        lineView.backgroundColor = Colors.lightGray
        lineView.tag = 999
        tabBar.addSubview(lineView)
    }
}
