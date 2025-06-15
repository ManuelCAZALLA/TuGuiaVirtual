//
//  SplashView.swift
//  TuGuiaVirtual
//
//  Created by Manuel Cazalla Colmenero on 8/6/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        if isActive {
            PlacesView()
        } else {
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Logo y título
                    VStack(spacing: 16) {
                        Image("TuGuia")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(rotation))
                            .scaleEffect(size)
                            .opacity(opacity)
                        
                        Text("Tu Guía Virtual")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .opacity(opacity)
                    }
                    
                    // Subtítulo
                    Text("Descubre lugares increíbles")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .opacity(opacity)
                    
                    // Indicador de carga personalizado
                    LoadingIndicator()
                        .padding(.top, 40)
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 1.0
                    self.opacity = 1.0
                }
                
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    self.rotation = 360
                }
                
                // Cambiar a la vista principal después de 3 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
