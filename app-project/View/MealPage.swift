import Foundation
import SwiftUI
import AVFoundation

struct MealPage: View {
    @EnvironmentObject var model: Model
    @State var showPageInvalidMessage = false
    @State var errorMessage = ""
    
    private var meal: RecipesList
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var hasSpokenDetails = false // State variable to track spoken status
    
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
                        
                        Text("\(meal.calories) kcal")
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
        }
        .navigationTitle("Meal Page")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            // Help Button
            Button(action: {
                HelpButtonPressed(status: HelpButtonState.MEAL_PAGE, synth: synth, meal: meal, cookingState: nil)
            }) {
                Text("?")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .opacity(0)
            }
            .accessibilityLabel("Help")

            // Repeat button
            Button(action: {
                speakRecipeDetails()
            }) {
                Text("Repeat")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .opacity(0)
            }
            .accessibilityLabel("Repeat")
        })
        .onAppear {
            hasToAnnounceHomepage = true // If this VStack appears, it means we will have to announce that we're in the homepage if we go back
            
            // Check if the details have already been spoken
            if !hasSpokenDetails {
                speakRecipeDetails()
            }
        }
    }

    private func speakRecipeDetails() {
        
        synth.stopSpeaking(at: .immediate)
        
        // Determine if the meal is vegetarian
        let vegetarianStatus = meal.vegetarian ? "This meal is vegetarian." : "This meal is not vegetarian."

        // Speak the details of the chosen recipe
        let detailsMessage = """
        \(vegetarianStatus)
        Here are the details for \(meal.recipeName):
        Difficulty: \(meal.difficulty),
        Time: \(meal.timeToCook) minutes,
        Calories: \(meal.calories) kcal,
        Servings: \(meal.servings).
        Ingredients: \(meal.ingredients).
        If you wish to hear the description again, just say "Tap Repeat".
        Otherwise, if you wish to start cooking, say "Tap Start".
        If you want to select another recipe, say "Tap Back".
        """
        SpeakMessage(str: detailsMessage, speechSynthesizer: synth)
        
        // Set the flag to true after speaking
        hasSpokenDetails = true
    }
}
