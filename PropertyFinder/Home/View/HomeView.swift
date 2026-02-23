//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var vm: GroceryViewModel

    init() {
        // Temporary container used only during initialisation.
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: GroceryItem.self, configurations: config)
        _vm = StateObject(wrappedValue: GroceryViewModel(modelContext: container.mainContext))
    }

    var body: some View {
        ZStack {
            Color(hex: "F2F2F7").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(vm: vm)
                    AddItemView(vm: vm)
                        .padding(.horizontal, 16)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
                    FilterBarView(vm: vm)
                    GroceryListView(vm: vm)
                }
            }
        }
        .sheet(item: $vm.editingItem) { item in
            EditItemSheet(vm: vm, item: item)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: GroceryItem.self, inMemory: true)
}
