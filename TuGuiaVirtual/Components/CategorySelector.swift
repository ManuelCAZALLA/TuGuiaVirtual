//
//  CategorySelector.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 1/6/25.
//

import SwiftUI

struct CategorySelectorView: View {
    @Binding var selectedCategory: PlaceCategory
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PlaceCategory.allCases) { category in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(category.emoji)
                                .font(.title3)
                            Text(category.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedCategory == category ? Color.accentColor : (colorScheme == .dark ? Color(.systemGray6) : .white))
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        )
                        .foregroundColor(selectedCategory == category ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CategorySelectorView(selectedCategory: .constant(.bar))
        .padding()
}
