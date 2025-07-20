//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.07.2025.
//

import UIKit

final class CategoriesViewModel {
    // MARK: - Properties
    private let categoryStore: TrackerCategoryStore
    private(set) var categories: [TrackerCategory] = []
    private(set) var selectedCategory: TrackerCategory?
    
    var onCategoriesUpdated: (() -> Void)?
    var onEmptyStateChanged: ((Bool) -> Void)?
    
    var isEmpty: Bool { categories.isEmpty }
    
    // MARK: - Init
    init(categoryStore: TrackerCategoryStore = TrackerCategoryStore()) {
        self.categoryStore = categoryStore
        loadCategories()
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        categories = categoryStore.fetchAllCategories()
        notifyObservers()
    }
    
    func addCategory(title: String) {
        do {
            try categoryStore.addCategory(title: title)
            loadCategories()
        } catch {
            print("Ошибка при добавлении категории: \(error.localizedDescription)")
        }
    }
    
    func updateCategory(at index: Int, newTitle: String) {
        guard index >= 0 && index < categories.count else { return }
        
        let category = categories[index]
        do {
            try categoryStore.updateCategory(category, newTitle: newTitle)
            loadCategories()
        } catch {
            print("Ошибка при обновлении категории: \(error.localizedDescription)")
        }
    }
    
    func deleteCategory(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        
        let category = categories[index]
        do {
            try categoryStore.deleteCategory(category)
            loadCategories()
        } catch {
            print("Ошибка при удалении категории: \(error.localizedDescription)")
        }
    }
    
    func selectCategory(_ category: TrackerCategory) {
        selectedCategory = category
        notifyObservers()
    }
    
    func selectCategory(with title: String) {
        selectedCategory = categories.first { $0.title == title }
        notifyObservers()
    }
    
    func getSelectedCategory() -> TrackerCategory? {
        return selectedCategory
    }
    
    // MARK: - Private Methods
    private func notifyObservers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.onCategoriesUpdated?()
            self.onEmptyStateChanged?(self.isEmpty)
        }
    }
}
