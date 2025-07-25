//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 25.07.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    // MARK: - Properties
    private lazy var pages: [UIViewController] = [
        OnboardingPageViewController(title: "Отслеживайте только то, что хотите", imageName: "onboarding1"),
        OnboardingPageViewController(title: "Даже если это\nне литры воды и йога", imageName: "onboarding2")
    ]
    
    private let pageControl = UIPageControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
        setupNotifications()
    }
    
    // MARK: - Private Methods
    private func setupPageViewController() {
        dataSource = self
        delegate = self
        setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = Colors.gray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(finishOnboarding),
            name: .onboardingSkipButtonTapped,
            object: nil
        )
    }
    
    // MARK: - Actions
    @objc private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        view.window?.rootViewController = TrackerTabBarController()
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let onboardingSkipButtonTapped = Notification.Name("onboardingSkipButtonTapped")
}
