//
//  KeyboardHandler.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 27.06.2025.
//

import UIKit

// MARK: - Public Methods
class KeyboardHandler: NSObject, UITextFieldDelegate {
    func setup(for viewController: UIViewController) {
        let tapGesture = UITapGestureRecognizer(target: viewController.view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
