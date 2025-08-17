//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 20.07.2025.
//

import UIKit

final class EditCategoryViewController: BaseCategoryViewController {
    // MARK: - Properties
    var onSave: ((UUID, String) -> Void)?
    private let categoryId: UUID
    private let currentCategoryName: String
    
    // MARK: - Lifecycle
    init(categoryId: UUID, currentName: String) {
        self.categoryId = categoryId
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
        onSave?(categoryId, categoryName)
        dismiss(animated: true)
    }
}
