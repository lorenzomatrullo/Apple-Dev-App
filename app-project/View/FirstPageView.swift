import Foundation
import SwiftUI
import AVFoundation

struct FirstPageView: View {
    @EnvironmentObject var model: Model
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    @State private var hasSpokenWelcomeMessage = false

    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.meal, id: \.self) { item in
                    NavigationLink(destination: MealPage(item)) {
                        RecipesView(item)
                    }.accessibilityLabel(item.recipeName)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Recipes")
                    .font(.title)
                    .bold()
                    .padding(.top, 15),
                trailing: Button(action: {
                                    // Action for the help button
                                    HelpButtonPressed(status: HelpButtonState.HOME_PAGE, synth: speechSynthesizer, meal: nil, cookingState: nil)
                                }) {
                                    Text("?")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44) // Size of the button
                                        .background(Color.red)
                                        .clipShape(Circle()) // Makes the button circular
                                        .shadow(radius: 5) // Optional shadow
                                        .opacity(0)
                                }
                                .accessibilityLabel("Help")
            )
            .onAppear {
                if !hasSpokenWelcomeMessage {
                    // Create a welcome message with the recipe names
                    var recipeNames = model.meal.map { $0.recipeName }
                    let formattedRecipeNames: String
                    
                    if recipeNames.count > 1 {
                        let lastRecipe = recipeNames.removeLast()
                        formattedRecipeNames = recipeNames.joined(separator: ", ") + " and " + lastRecipe
                    } else {
                        formattedRecipeNames = recipeNames.first ?? ""
                    }
                    
                    let welcomeMessage = "Welcome to TasteEcho, let's explore delicious recipes. You can choose between: \(formattedRecipeNames)."
                    
                    SpeakMessage(str: welcomeMessage, speechSynthesizer: speechSynthesizer)

                    // Add warning message about enabling voice control
                    let voiceControlMessage = "Warning: Enable Voice Control to continue using the app. If you don't have it enabled, just say, 'Hey Siri, enable Voice Control.'"
                    SpeakMessage(str: voiceControlMessage, speechSynthesizer: speechSynthesizer)

                    // Add message about using voice commands
                    let commandMessage = "After enabling it, just say 'tap' followed by the recipe name, like 'tap tomato pasta' or 'tap salad'."
                    SpeakMessage(str: commandMessage, speechSynthesizer: speechSynthesizer)

                    hasSpokenWelcomeMessage = true
                }
            }
        }
    }
}
