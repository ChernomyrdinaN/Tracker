//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 20.07.2025.
//

import UIKit

final class EditCategoryViewController: BaseCategoryViewController {
    // MARK: - Properties
    private let currentCategoryName: String
    var onSave: ((String) -> Void)?
    
    // MARK: - Lifecycle
    init(currentName: String) {
        self.currentCategoryName = currentName
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = "Редактирование категории"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = currentCategoryName
    }
    
    // MARK: - Overridden Methods
    @objc override func doneButtonTapped() {
        guard let categoryName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !categoryName.isEmpty else { return }
        onSave?(categoryName)
        dismiss(animated: true)
    }
}
