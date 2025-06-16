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
        setupTabBarAppearance()
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
        
        private func setupTabBarAppearance(){
            tabBar.barTintColor = Colors.whiteNight
            tabBar.tintColor = Colors.blue
            tabBar.unselectedItemTintColor = Colors.gray
        }
    }
