//
//  NearbyButton.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 1/6/25.
//

import SwiftUI

struct NearbyButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "location.fill")
                Text("Cerca de mí")
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green)
                    .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
            )
            .foregroundColor(.white)
        }
    }
}

#Preview {
    NearbyButton(action: {})
        .padding()
        
}
