//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI

struct AddItemView: View {
    @ObservedObject var vm: GroceryViewModel
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Gradient Banner
            ZStack(alignment: .leading) {
                LinearGradient(
                    colors: [Color(hex: "9B6FE8"), Color(hex: "6A8EE8")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                Text("Add New Item")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.vertical, 18)
            }
            .cornerRadius(16, corners: [.topLeft, .topRight])
            
            //Form Body
            VStack(alignment: .leading, spacing: 0) {
                Text("Item Name")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                
                TextField("Enter grocery item...", text: $vm.itemName)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(14)
                    .background(Color(hex: "F2F2F7"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                vm.showError ? Color.red.opacity(0.6) : Color.clear,
                                lineWidth: 1.5
                            )
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .focused($fieldFocused)
                    .submitLabel(.done)
                    .onSubmit { vm.addItem() }
                    .onChange(of: vm.itemName) { vm.showError = false }
                
                if vm.showError {
                    Text("Please enter an item name")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 18)
                        .padding(.top, 4)
                }
                
                Text("Category")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                
                // Category tiles
                HStack(spacing: 10) {
                    ForEach(GroceryCategory.allCases, id: \.self) { cat in
                        CategoryTileView(
                            category: cat,
                            isSelected: vm.selectedCat == cat
                        ) {
                            withAnimation(.spring(response: 0.2)) {
                                vm.selectedCat = cat
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Add Button
                Button {
                    fieldFocused = false
                    vm.addItem()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add Item")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(hex: "8E8E93"))
                    .cornerRadius(14)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
    }
}

// MARK: - Category Tile view

struct CategoryTileView: View {
    let category: GroceryCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? category.activeColor : category.lightColor)
                        .frame(height: 58)
                    VStack {
                        Text(category.emoji)
                            .font(.system(size: 26))
                        Text(category.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(isSelected ? .white : category.labelColor)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.plain)
    }
}
