//
//  PropertyFinderApp.swift
//  PropertyFinder
//
//  Created by Sumit Kumar on 23/02/26.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var vm: GroceryViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Cart circle
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "9B6FE8"), Color(hex: "6A8EE8")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                Image(systemName: "cart.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            .padding(.top, 36)
            
            Text("Grocery List")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            Text("Add items to your shopping list")
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "8E8E93"))
            
            // Progress bar — only when items exist
            if !vm.items.isEmpty {
                HStack(spacing: 10) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(hex: "E5E5EA"))
                                .frame(height: 6)
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "9B6FE8"), Color(hex: "6A8EE8")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: geo.size.width * (vm.items.isEmpty ? 0 : CGFloat(vm.completedCount) / CGFloat(vm.items.count)),
                                    height: 6
                                )
                                .animation(.spring(response: 0.4), value: vm.completedCount)
                        }
                    }
                    .frame(height: 6)
                    
                    Text("\(vm.completedCount)/\(vm.items.count)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "8E8E93"))
                        .frame(minWidth: 40, alignment: .trailing)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                if vm.completedCount > 0 {
                    Button(action: vm.clearCompleted) {
                        Text("Clear completed (\(vm.completedCount))")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "9B6FE8"))
                    }
                    .padding(.top, 2)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
    }
}
