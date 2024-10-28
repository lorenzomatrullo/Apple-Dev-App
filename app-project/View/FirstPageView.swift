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
        let utterance = AVSpeechUtterance(string: welcomeMessage)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // utterance.rate = 0.5
        
        speechSynthesizer.speak(utterance)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPageView().environmentObject(Model())
    }
}
