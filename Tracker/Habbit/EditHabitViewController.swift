//
//  EditHabitViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 27.07.2025.
//

import UIKit

final class EditHabitViewController: HabitCreationViewController {
    // MARK: - Properties
    private let tracker: Tracker
    private let originalCategory: TrackerCategory
    private let trackerStore: TrackerStore
    
    // MARK: - Init
    init(tracker: Tracker, category: TrackerCategory, trackerStore: TrackerStore) {
        self.tracker = tracker
        self.originalCategory = category
        self.trackerStore = trackerStore
        super.init(nibName: nil, bundle: nil)
        setupInitialValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Редактирование привычки"
        createButton.setTitle("Сохранить", for: .normal)
    }
    
    // MARK: - Private Methods
    private func setupInitialValues() {
        nameTextField.text = tracker.name
        selectedCategory = originalCategory
        selectedEmoji = tracker.emoji
        selectedColor = UIColor(named: tracker.colorAssetName)
        selectedSchedule = Set(tracker.schedule)
        
        updateCategoryButtonTitle()
        updateScheduleButtonTitle()
        emojiCollectionView.selectedEmoji = tracker.emoji
        colorCollectionView.selectedColor = UIColor(named: tracker.colorAssetName)
        updateCreateButtonState()
    }
    
    // MARK: - Actions
    @objc override func createButtonTapped() {
        guard let name = nameTextField.text,
              let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor else { return }
        
        let updatedTracker = Tracker(
            id: tracker.id,
            name: name,
            color: Colors.colorName(for: selectedColor) ?? "Color selection 1",
            emoji: selectedEmoji,
            schedule: Array(selectedSchedule),
            colorAssetName: Colors.colorName(for: selectedColor) ?? "Color selection 1"
        )
        
        onTrackerCreated?(updatedTracker)
        dismiss(animated: true)
    }
}
