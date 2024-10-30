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
                }
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
