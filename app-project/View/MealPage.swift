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
        VStack (spacing: -50) {
            Form {
                RecipesView(meal)
                
                mealDetailsSection
                
                ingredientsSection
            }
            
            startButton
        }
        .navigationTitle("Meal Page")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: navigationButtons)
        .onAppear {
            hasToAnnounceHomepage = true
            
            // Check if the details have already been spoken
            if !hasSpokenDetails {
                speakRecipeDetails()
            }
        }
    }
    
    private var mealDetailsSection: some View {
        VStack(alignment: .leading) {
            detailRow(title: "TIME:", value: "\(meal.timeToCook) minutes")
            detailRow(title: "CALORIES:", value: "\(meal.calories) kcal")
            detailRow(title: "SERVINGS:", value: "\(meal.servings)")
        }
        .padding(.top, 10)
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var ingredientsSection: some View {
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
    
    private var startButton: some View {
        NavigationLink(destination: StepPageView(meal)) {
            Text("Start")
                .font(.system(size: 20, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
        }
        .buttonStyle(.borderedProminent)
        .tint(.blue) // Adds the system blue color (like Apple's button color)
        .cornerRadius(8) // Rounded corners for a more Apple-like look
    }

    
    private var navigationButtons: some View {
        HStack {
            helpButton
            repeatButton
        }
    }
    
    private var helpButton: some View {
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
                .opacity(0) // Adjust opacity as needed
        }
        .accessibilityLabel("Help")
    }
    
    private var repeatButton: some View {
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
                .opacity(0) // Adjust opacity as needed
        }
        .accessibilityLabel("Repeat")
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

