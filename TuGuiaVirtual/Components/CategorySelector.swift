//
//  CategorySelector.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 1/6/25.
//

import SwiftUI

struct CategorySelectorView: View {
    @Binding var selectedCategory: PlaceCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(PlaceCategory.allCases) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text("\(category.emoji) \(category.displayName)")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.accentColor : Color.white)
                            .foregroundColor(selectedCategory == category ? .white : .black)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
