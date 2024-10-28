import Foundation
import SwiftUI
import AVFoundation

struct FirstPageView: View {
    @EnvironmentObject var model: Model
    private let speechSynthesizer = AVSpeechSynthesizer()
    @State private var hasSpokenWelcomeMessage = false  // Track if the message has been spoken
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.model.recipes, id: \.self) { item in
                    NavigationLink(destination: MealPage(item)) {
                        RecipesView(item)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Text("Recipes")
                .font(.title)
                .bold()
                .foregroundColor(.primary)
                .padding(.top, 15)
            )
            .onAppear {
                if !hasSpokenWelcomeMessage {
                    speakWelcomeMessage()
                    hasSpokenWelcomeMessage = true  // Update the state to prevent future calls
                }
            }
        }
    }
    
    private func speakWelcomeMessage() {
        let welcomeMessage = "Welcome to the Recipe App! Explore delicious recipes."
        let recipeChoices = "You can choose between: "
        
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let welcomeMessageUtterance = AVSpeechUtterance(string: welcomeMessage)
        welcomeMessageUtterance.voice = voice
        
        let recipeChoiceUtterance = AVSpeechUtterance(string: recipeChoices)
        recipeChoiceUtterance.voice = voice
        
        speechSynthesizer.speak(welcomeMessageUtterance)
        speechSynthesizer.speak(recipeChoiceUtterance)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView().environmentObject(Model())
    }
}
