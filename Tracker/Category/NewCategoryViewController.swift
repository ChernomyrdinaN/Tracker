//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 17.07.2025.
//

import UIKit

final class NewCategoryViewController: BaseCategoryViewController {
    // MARK: - Properties
    var onCategoryCreated: ((String) -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = "Новая категория"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden Methods
    @objc override func doneButtonTapped() {
        guard let categoryName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !categoryName.isEmpty else { return }
        onCategoryCreated?(categoryName)
        dismiss(animated: true)
    }
}
