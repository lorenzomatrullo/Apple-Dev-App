import Foundation
import SwiftUI
import AVFoundation

struct FirstPageView: View {
    @EnvironmentObject var model: Model
    @State private var hasSpokenWelcomeMessage = false
    @State private var isFirstLaunch: Bool

    @State public var navigationPath = NavigationPath()

    init() {
        // Prevent the phone from timing out because of no touch interaction while the app is open
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Initialize isFirstLaunch based on UserDefaults
        _isFirstLaunch = State(initialValue: UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false)
    }

    var body: some View {
        NavigationStack(path: $navigationPath)  {
            List {
                ForEach(self.model.meal, id: \.self) { item in
                    NavigationLink(destination: MealPage(item)) {
                        RecipesView(item)
                    }
                    .accessibilityLabel(item.recipeName)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Recipes")
                    .font(.title)
                    .bold()
                    .padding(.top, 15),
                trailing: HStack {
                    HelpButton()
                    RepeatButton()
                }
            )
            .onAppear {
                handleOnAppear()
            }
        }
    }

    // Help Button
    private func HelpButton() -> some View {
        Button(action: {
            HelpButtonPressed(status: HelpButtonState.HOME_PAGE, synth: synth, meal: nil, cookingState: nil)
        }) {
            Text("?")
                .opacity(0)
        }
        .accessibilityLabel("Help")
        .allowsHitTesting(false)
    }

    // Repeat Button
    private func RepeatButton() -> some View {
        Button(action: {
            hasSpokenWelcomeMessage = false
            SpeakHomepageMessage()
        }) {
            Text("Repeat")
                .opacity(0)
        }
        .accessibilityLabel("Repeat")
        .allowsHitTesting(false)
    }

    // Handle First Page Appearance
    private func handleOnAppear() {
        
        // This handles the situation where you close the initial voice control alert before the TTS has finished speaking, if you tap OK the TTS will stop and it will start directly with the homepage dialogue
        if(firstTimeOnHomepage)
        {
            synth.stopSpeaking(at: .immediate)
            firstTimeOnHomepage = false;
        }
        
        if hasToAnnounceHomepage {
            synth.stopSpeaking(at: .immediate)
            SpeakMessage(str: "We are back at the cookbook page!", speechSynthesizer: synth)
            
            let commandMessage = "To get started with a recipe, you can just say 'tap' followed by the recipe name, like 'tap tomato pasta'. Or 'tap salad'."
            SpeakMessage(str: commandMessage, speechSynthesizer: synth)
            
            hasToAnnounceHomepage = false
        }
        
        SpeakHomepageMessage()
    }
    

    // Speak Welcome Message
    private func SpeakHomepageMessage() {
        guard !hasSpokenWelcomeMessage else { return }

        if isFirstLaunch {
            // First launch - Show full welcome message
            var recipeNames = model.meal.map { $0.recipeName }
            let formattedRecipeNames: String

            if recipeNames.count > 1 {
                let lastRecipe = recipeNames.removeLast()
                formattedRecipeNames = recipeNames.joined(separator: ", ") + " and " + lastRecipe
            } else {
                formattedRecipeNames = recipeNames.first ?? ""
            }
            
            let welcomeMessage = """
            Welcome to TasteEcho. Here’s your cooking instruction. I’ll guide you step by step.
            To start a recipe, just say 'tap' and then the recipe name. Like 'Tap tomato pasta', or, 'tap salad' to begin.
            You can always say “tap Repeat”, if you want to hear each step one more time. Or say, “tap Help”, if you don’t remember how to navigate through the steps.
            
            
            Let’s start cooking, I will wait for your answer.
            """

            //let welcomeMessage = "Welcome to TasteEcho, let's explore delicious recipes. You can choose between: \(formattedRecipeNames)."
            SpeakMessage(str: welcomeMessage, speechSynthesizer: synth)
            
            /*
            // Add message about using voice commands
            let commandMessage = "To get started with a recipe, you can just say 'tap' followed by the recipe name, like 'tap tomato pasta'. Or 'tap salad'."
            SpeakMessage(str: commandMessage, speechSynthesizer: synth)
            
            let helpMsg = "Remember you can always say 'Tap Repeat' to make me repeat the instructions. Or you can say 'Tap Help' to get help on the page you're currently in."
            SpeakMessage(str: helpMsg, speechSynthesizer: synth)
            */
            
            // Mark first launch as completed
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        } else {
            // Subsequent launches - Show shorter message
            let shortMessage = "Welcome back to TasteEcho. Let's start cooking, you can choose between tomato pasta, or, salad, I will wait for your answer."
            SpeakMessage(str: shortMessage, speechSynthesizer: synth)
        }

        hasSpokenWelcomeMessage = true
    }
}
