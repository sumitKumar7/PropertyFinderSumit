import SwiftUI

// MARK: - List Container

struct GroceryListView: View {
    @ObservedObject var vm: GroceryViewModel

    var body: some View {
        Group {
            if vm.filteredItems.isEmpty {
                EmptyStateView(isFiltered: vm.filterCat != nil)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(vm.filteredItems) { item in
                        GroceryRowView(
                            item:     item,
                            onToggle: { vm.toggleItem(item) },
                            onEdit:   { vm.editingItem = item },
                            onDelete: { vm.deleteItem(item) }
                        )
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal:   .move(edge: .trailing).combined(with: .opacity)
                        ))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Row

struct GroceryRowView: View {
    let item:     GroceryItem
    let onToggle: () -> Void
    let onEdit:   () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {

            // Completion toggle
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            item.isCompleted ? item.category.activeColor : Color(hex: "C7C7CC"),
                            lineWidth: 2
                        )
                        .frame(width: 26, height: 26)
                    if item.isCompleted {
                        Circle()
                            .fill(item.category.activeColor)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            // Category emoji badge
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(item.category.lightColor)
                    .frame(width: 42, height: 42)
                Text(item.category.emoji)
                    .font(.system(size: 22))
            }

            // Name + category label
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(item.isCompleted ? Color(hex: "8E8E93") : .black)
                    .strikethrough(item.isCompleted, color: Color(hex: "8E8E93"))
                    .animation(.easeInOut(duration: 0.2), value: item.isCompleted)

                Text(item.category.rawValue)
                    .font(.system(size: 12))
                    .foregroundColor(item.category.activeColor)
            }

            Spacer()

            // Edit + Delete buttons
            HStack(spacing: 6) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .frame(width: 32, height: 32)
                        .background(Color(hex: "F2F2F7"))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "F44336").opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(Color(hex: "FFEBEE"))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .opacity(item.isCompleted ? 0.72 : 1)
        .animation(.easeInOut(duration: 0.2), value: item.isCompleted)
    }
}

//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//


struct EmptyStateView: View {
    let isFiltered: Bool

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isFiltered ? "line.3.horizontal.decrease.circle" : "cart")
                .font(.system(size: 52))
                .foregroundColor(Color(hex: "C7C7CC"))
                .padding(.top, 50)

            Text(isFiltered ? "No items in this category" : "Your grocery list is empty")
                .font(.system(size: 17))
                .foregroundColor(Color(hex: "8E8E93"))

            Text(isFiltered ? "Try selecting a different filter" : "Add items above to get started")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "C7C7CC"))
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 40)
    }
}
