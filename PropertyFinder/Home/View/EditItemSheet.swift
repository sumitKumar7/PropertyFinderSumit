//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI

struct EditItemSheet: View {
    @ObservedObject var vm: GroceryViewModel
    let item: GroceryItem
    
    @State private var editName: String
    @State private var editCat: GroceryCategory
    @State private var showError = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(vm: GroceryViewModel, item: GroceryItem) {
        self.vm   = vm
        self.item = item
        _editName = State(initialValue: item.name)
        _editCat  = State(initialValue: item.category)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Gradient banner
                ZStack(alignment: .leading) {
                    LinearGradient(
                        colors: [Color(hex: "9B6FE8"), Color(hex: "6A8EE8")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    Text("Edit Item")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                        .padding(.vertical, 18)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Name field
                    Text("Item Name")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 24)
                        .padding(.horizontal, 20)
                    
                    TextField("Enter grocery item...", text: $editName)
                        .font(.system(size: 16))
                        .padding(14)
                        .background(Color(hex: "F2F2F7"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    showError ? Color.red.opacity(0.6) : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .onChange(of: editName) { showError = false }
                    
                    if showError {
                        Text("Please enter an item name")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 22)
                            .padding(.top, 4)
                    }
                    
                    // Category
                    Text("Category")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    
                    HStack(spacing: 10) {
                        ForEach(GroceryCategory.allCases, id: \.self) { cat in
                            CategoryTileView(
                                category:   cat,
                                isSelected: editCat == cat
                            ) {
                                withAnimation(.spring(response: 0.2)) { editCat = cat }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    
                    // Save button
                    Button {
                        let trimmed = editName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else {
                            showError = true
                            return
                        }
                        vm.saveEdit(name: trimmed, category: editCat)
                        dismiss()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Save Changes")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "9B6FE8"), Color(hex: "6A8EE8")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 28)
                    
                    Spacer()
                }
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Color(hex: "9B6FE8"))
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
