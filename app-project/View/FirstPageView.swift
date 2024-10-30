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
                .padding(.top, 20) // if you put a value over 20 the text is gonna get cutted
                //.padding(.top, 100)
            )
            .onAppear {
                if !hasSpokenWelcomeMessage {
                    SpeakMessage(str: "Welcome to the Recipe App! Explore delicious recipes.", speechSynthesizer: speechSynthesizer)
                    SpeakMessage(str: "You can choose between:", speechSynthesizer: speechSynthesizer)
                    hasSpokenWelcomeMessage = true
                }
            }
            //.padding(.top, 30) // this moves the recipes
            //.background(Color(red: 242/255, green: 242/255, blue: 247/255))
        }
    }
}
