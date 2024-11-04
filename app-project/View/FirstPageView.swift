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
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Text("Recipes")
                    .font(.title)
                    .bold()
                    .padding(.top, 15)
            )
            .onAppear {
                if !hasSpokenWelcomeMessage {
                    SpeakMessage(str: "Welcome to the Recipe App! Explore delicious recipes.", speechSynthesizer: speechSynthesizer)
                    SpeakMessage(str: "You can choose between:", speechSynthesizer: speechSynthesizer)
                    hasSpokenWelcomeMessage = true
                }
            }
        }
    }
}
