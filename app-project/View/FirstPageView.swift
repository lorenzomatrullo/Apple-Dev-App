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
                trailing: HStack {
                    // Help Button
                    Button(action: {
                        HelpButtonPressed(status: HelpButtonState.HOME_PAGE, synth: speechSynthesizer, meal: nil, cookingState: nil)                    }) {
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
                        // Let the welcome message repeat
                        hasSpokenWelcomeMessage = false
                        SpeakHomepageMessage()
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
                if(hasToAnnounceHomepage)
                {
                    SpeakMessage(str: "We are back on the homepage!", speechSynthesizer: speechSynthesizer)
                    
                    // Remember the user what it can do
                    let commandMessage = "To get started with a recipe, you can just say 'tap' followed by the recipe name, like 'tap tomato pasta'. Or 'tap salad'."
                    SpeakMessage(str: commandMessage, speechSynthesizer: speechSynthesizer)
                    
                    hasToAnnounceHomepage = false
                }
                
                SpeakHomepageMessage()
            }
        }
    }
    
    private func SpeakHomepageMessage() {
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
            
            // Add message about using voice commands
            let commandMessage = "To get started with a recipe, you can just say 'tap' followed by the recipe name, like 'tap tomato pasta'. Or 'tap salad'."
            SpeakMessage(str: commandMessage, speechSynthesizer: speechSynthesizer)
            
            let helpMsg = "Remember you can alway say 'Tap Repeat', to make me repeat the instructions. Or you can say 'Tap Help' to get help on the page you're currently in."
            SpeakMessage(str: helpMsg, speechSynthesizer: speechSynthesizer)

            hasSpokenWelcomeMessage = true
        }
    }
}
