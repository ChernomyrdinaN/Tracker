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
        setupViewControllers()
       // setupTabBarAppearance()
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            addTopBorderToTabBar()
        }
    
    private func setupViewControllers() {
        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()
        
        trackersVC.tabBarItem = UITabBarItem(
            title: "Трекеры", image: UIImage(named: "trackers_icon"),
            tag: 0)
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика", image: UIImage(named: "statistics_icon"),
            tag: 1)
        
        viewControllers = [trackersVC, statisticsVC]
    }
    
    
    private func addTopBorderToTabBar() {
        guard tabBar.viewWithTag(999) == nil else { return }
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1))
        lineView.backgroundColor = Colors.lightGray
        lineView.tag = 999
        tabBar.addSubview(lineView)
    }
}
