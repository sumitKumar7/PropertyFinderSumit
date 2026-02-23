//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI
import SwiftData
import Combine


@MainActor
final class GroceryViewModel: ObservableObject {

    // MARK: - SwiftData Context
    private let modelContext: ModelContext

    // MARK: - Published UI State
    @Published var items:       [GroceryItem]    = []
    @Published var itemName:    String           = ""
    @Published var selectedCat: GroceryCategory  = .milk
    @Published var filterCat:   GroceryCategory? = nil
    @Published var showError:   Bool             = false
    @Published var editingItem: GroceryItem?     = nil

    // MARK: - Computed Properties

    var filteredItems: [GroceryItem] {
        guard let filter = filterCat else { return items }
        return items.filter { $0.category == filter }
    }

    var completedCount: Int {
        items.filter(\.isCompleted).count
    }

    var categoriesInUse: [GroceryCategory] {
        GroceryCategory.allCases.filter { cat in
            items.contains { $0.category == cat }
        }
    }

    // MARK: - Init

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchItems()
    }

    // MARK: - Fetch Data

    func fetchItems() {
        let descriptor = FetchDescriptor<GroceryItem>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )
        do {
            items = try modelContext.fetch(descriptor)
        } catch {
            debugPrint("Fetch failed: \(error.localizedDescription)")
        }
    }

    func addItem() {
        let trimmed = itemName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            showError = true
            return
        }
        let newItem = GroceryItem(name: trimmed, category: selectedCat)
        modelContext.insert(newItem)
        save()
        withAnimation(.spring(response: 0.3)) {
            items.insert(newItem, at: 0)
        }
        itemName  = ""
        showError = false
    }

    // MARK: - Update: Toggle Completion

    func toggleItem(_ item: GroceryItem) {
        withAnimation(.spring(response: 0.25)) {
            item.isCompleted.toggle()
        }
        save()
    }

    // MARK: - Update: Edit Name & Category

    func saveEdit(name: String, category: GroceryCategory) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, let target = editingItem else { return }
        withAnimation(.spring(response: 0.25)) {
            target.name     = trimmed
            target.category = category
        }
        save()
        fetchItems()          // re-sort after edit
        editingItem = nil
    }

    // MARK: - Delete: Single Item

    func deleteItem(_ item: GroceryItem) {
        withAnimation(.easeInOut(duration: 0.25)) {
            items.removeAll { $0.id == item.id }
        }
        modelContext.delete(item)
        save()
        if editingItem?.id == item.id { editingItem = nil }
    }

    // MARK: - Delete: Swipe-to-delete from IndexSet

    func deleteItems(at offsets: IndexSet) {
        let targets = offsets.map { filteredItems[$0] }
        withAnimation {
            targets.forEach { item in
                items.removeAll { $0.id == item.id }
                modelContext.delete(item)
            }
        }
        save()
    }

    // MARK: - Delete: All Completed

    func clearCompleted() {
        let completed = items.filter(\.isCompleted)
        withAnimation(.easeInOut(duration: 0.25)) {
            items.removeAll(\.isCompleted)
        }
        completed.forEach { modelContext.delete($0) }
        save()
    }

    // MARK: - Filter

    func setFilter(_ cat: GroceryCategory?) {
        withAnimation(.easeInOut(duration: 0.2)) {
            filterCat = (filterCat == cat) ? nil : cat
        }
    }

    // MARK: - Persist

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("❌ Save failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Convenience

private extension Array {
    mutating func removeAll(_ keyPath: KeyPath<Element, Bool>) {
        removeAll { $0[keyPath: keyPath] }
    }
}
