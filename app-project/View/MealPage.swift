import Foundation
import SwiftUI
import AVFoundation

struct MealPage: View {
    @EnvironmentObject var model: Model
    @State var showPageInvalidMessage = false
    @State var errorMessage = ""
    
    private let synth = AVSpeechSynthesizer()
    private var meal: RecipesList
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    init(_ meal: RecipesList) {
        self.meal = meal
    }
    
    var body: some View {
        VStack {
            Form {
                RecipesView(meal)

                VStack(alignment: .leading) {
                    HStack {
                        Text("TIME:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(meal.timeToCook) minutes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("CALORIES:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(meal.calories)kcal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("SERVINGS:")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("\(meal.servings)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 10)
                
                Section(header: Text("Ingredients")
                    .font(.headline)
                    .foregroundColor(.primary)
                ) {
                    // Split the ingredients string into an array
                    let ingredientsList = meal.ingredients.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                    
                    ForEach(ingredientsList, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                }
            }
            
            NavigationLink(destination: StepPageView(meal)) {
                Text("START")
                    .font(.system(size: 25))
                    .bold()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .buttonStyle(.borderedProminent)
            .accessibilityInputLabels(["start"])
        }
        .navigationTitle("Meal Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}
