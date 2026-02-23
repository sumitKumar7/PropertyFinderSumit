//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI
import SwiftData


enum GroceryCategory: String, CaseIterable, Codable {
    case milk = "Milk"
    case vegetables = "Vegetables"
    case fruits = "Fruits"
    case breads = "Breads"
    case meats = "Meats"

    var emoji: String {
        switch self {
        case .milk:
            return "🥛"
        case .vegetables:
            return "🥕"
        case .fruits:
            return "🍎"
        case .breads:
            return "🍞"
        case .meats:
            return "🥩"
        }
    }

    var activeColor: Color {
        switch self {
        case .milk:
            return Color(hex: "2196F3")
        case .vegetables:
            return Color(hex: "4CAF50")
        case .fruits:
            return Color(hex: "F44336")
        case .breads:
            return Color(hex: "FF9800")
        case .meats:
            return Color(hex: "E91E8C")
        }
    }

    var lightColor: Color {
        switch self {
        case .milk:
            return Color(hex: "E3F2FD")
        case .vegetables:
            return Color(hex: "E8F5E9")
        case .fruits:
            return Color(hex: "FFEBEE")
        case .breads:
            return Color(hex: "FFF3E0")
        case .meats:
            return Color(hex: "FCE4EC")
        }
    }

    var labelColor: Color {
        switch self {
        case .milk:
            return Color(hex: "1565C0")
        case .vegetables:
            return Color(hex: "2E7D32")
        case .fruits:
            return Color(hex: "C62828")
        case .breads:
            return Color(hex: "E65100")
        case .meats:
            return Color(hex: "880E4F")
        }
    }
}

// MARK: - SwiftData Model

@Model
final class GroceryItem {
    var id: UUID
    var name: String
    var category: GroceryCategory
    var isCompleted: Bool
    var dateAdded: Date

    init(name: String, category: GroceryCategory) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.isCompleted = false
        self.dateAdded = Date()
    }
}
