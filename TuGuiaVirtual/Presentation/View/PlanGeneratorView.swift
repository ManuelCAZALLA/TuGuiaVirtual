import SwiftUI

struct PlanGeneratorView: View {
    @StateObject private var viewModel = PlanGeneratorViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("¿Dónde quieres explorar?")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(spacing: 16) {
                            // Toggle para usar ubicación actual
                            Toggle(isOn: $viewModel.useCurrentLocation) {
                                HStack {
                                    Image(systemName: "location.fill")
                                        .foregroundColor(.accentColor)
                                    Text("Usar mi ubicación actual")
                                        .font(.subheadline)
                                }
                            }
                            .tint(.accentColor)
                            
                            if !viewModel.useCurrentLocation {
                                // Campo de entrada de ciudad
                                HStack {
                                    Image(systemName: "building.2.fill")
                                        .foregroundColor(.secondary)
                                    TextField("Introduce una ciudad", text: $viewModel.cityInput)
                                        .textFieldStyle(PlainTextFieldStyle())
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Selector de duración
                    VStack(alignment: .leading, spacing: 12) {
                        Text("¿Cuánto tiempo tienes?")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(PlanDuration.allCases, id: \.rawValue) { duration in
                                    Button(action: {
                                        viewModel.selectedDuration = duration
                                    }) {
                                        Text(duration.displayName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(viewModel.selectedDuration == duration ? Color.accentColor : (colorScheme == .dark ? Color(.systemGray6) : .white))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                            )
                                            .foregroundColor(viewModel.selectedDuration == duration ? .white : .primary)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Selector de categorías
                    VStack(alignment: .leading, spacing: 12) {
                        Text("¿Qué te apetece hacer?")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
                            ForEach(PlaceCategory.allCases) { category in
                                Button(action: {
                                    if viewModel.selectedCategories.contains(category) {
                                        viewModel.selectedCategories.remove(category)
                                    } else {
                                        viewModel.selectedCategories.insert(category)
                                    }
                                }) {
                                    HStack {
                                        Text(category.emoji)
                                            .font(.title3)
                                        Text(category.displayName)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.selectedCategories.contains(category) ? Color.accentColor : (colorScheme == .dark ? Color(.systemGray6) : .white))
                                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                    )
                                    .foregroundColor(viewModel.selectedCategories.contains(category) ? .white : .primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Botón de generación
                    Button(action: {
                        viewModel.generatePlan()
                    }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("Generar Plan")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accentColor)
                                .shadow(color: Color.accentColor.opacity(0.3), radius: 5, x: 0, y: 3)
                        )
                        .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.selectedCategories.isEmpty)
                    .opacity(viewModel.selectedCategories.isEmpty ? 0.6 : 1)
                    
                    if let error = viewModel.errorMessage {
                        Text("⚠️ \(error)")
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.1))
                            )
                            .padding(.horizontal)
                    }
                    
                    if viewModel.isLoading {
                        LoadingIndicator()
                            .padding()
                    }
                    
                    if let plan = viewModel.generatedPlan {
                        PlanDetailView(plan: plan)
                    }
                }
                .padding(.vertical)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.backgroundGradientStart, .backgroundGradientEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Generar Plan")
        }
    }
}

struct PlanDetailView: View {
    let plan: Plan
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(plan.name)
                .font(.title2)
                .bold()
            
            HStack {
                VStack(alignment: .leading) {
                    Label("\(Int(plan.totalDistance/1000)) km", systemImage: "figure.walk")
                    Label("\(Int(plan.estimatedCost))€", systemImage: "eurosign.circle")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            ForEach(plan.activities) { activity in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(activity.order).")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        Text(activity.place.name ?? "Sin nombre")
                            .font(.headline)
                    }
                    
                    if let street = activity.place.street {
                        Text(street)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text(activity.category.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text("\(Int(activity.estimatedDuration/60)) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
            }
        }
        .padding()
    }
}

#Preview {
    PlanGeneratorView()
} 
