//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI

struct FilterBarView: View {
    @ObservedObject var vm: GroceryViewModel
    
    var body: some View {
        if !vm.items.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    
                    // "All" chip
                    FilterChip(
                        label: "All",
                        emoji: "🛒",
                        isSelected: vm.filterCat == nil,
                        activeColor: Color(hex: "9B6FE8"),
                        lightColor:  Color(hex: "F3EEFF"),
                        labelColor:  Color(hex: "9B6FE8")
                    ) {
                        vm.setFilter(nil)
                    }
                    
                    // Per-category chips — only categories that have at least one item
                    ForEach(vm.categoriesInUse, id: \.self) { cat in
                        FilterChip(label: cat.rawValue,
                                   emoji: cat.emoji,
                                   isSelected: vm.filterCat == cat,
                                   activeColor: cat.activeColor,
                                   lightColor: cat.lightColor,
                                   labelColor: cat.labelColor
                        ) {
                            vm.setFilter(cat)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let label: String
    let emoji: String
    let isSelected: Bool
    let activeColor: Color
    let lightColor: Color
    let labelColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji).font(.footnote)
                Text(label)
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isSelected ? lightColor : Color(hex: "EBEBF0"))
            .foregroundColor(isSelected ? activeColor : Color(hex: "6E6E73"))
            .cornerRadius(20)
            .overlay(
                Capsule().strokeBorder(
                    isSelected ? activeColor.opacity(0.5) : Color.clear,
                    lineWidth: 1.5
                )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
