//
//  SplashView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 8/6/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            PlacesView()
        } else {
            ZStack {
                Image("Splash")
                    .resizable()
                    .ignoresSafeArea()
                
                LoadingIndicator()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
