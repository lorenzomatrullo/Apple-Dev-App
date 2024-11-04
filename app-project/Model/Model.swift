import Foundation
import SwiftUI
import AVFoundation

// Model for a recipe
public struct RecipesList: Hashable {
    let recipeName: String
    let ingredients: String
    let numberOfSteps: Int
    let imageName: String
    let difficulty: String
    let timeToCook: Int
    let calories: Int
    let servings: Int
    let vegetarian: Bool
    let lactoseFree: Bool
    let glutenFree: Bool
    let steps: [RecipeStep] // Array of steps
    
    init(recipeName: String = "", ingredients: String = "", numberOfSteps: Int = 0, imageName: String = "", difficulty: String = "", timeToCook: Int = 0, calories: Int = 0, servings: Int = 1, vegetarian: Bool = false, lactoseFree: Bool = false, glutenFree: Bool = false ,steps: [RecipeStep] = []) {
        
        self.recipeName = recipeName
        self.ingredients = ingredients
        self.numberOfSteps = numberOfSteps
        self.imageName = imageName
        self.difficulty = difficulty
        self.timeToCook = timeToCook
        self.calories = calories
        self.servings = servings
        self.vegetarian = vegetarian
        self.lactoseFree = lactoseFree
        self.glutenFree = glutenFree
        self.steps = steps
    }
}

// Wrapper for steps variables
struct RecipeStep: Hashable {
    let step: String
    let imageName: String
    let description: String
    let speakSteps: String
    
    let usesTimer: Bool
    let timerTime: Int // time in seconds
}

public struct CookingState {
    var currentStep: Int
}

struct MealPageModel: Identifiable {
    var id = UUID()
    var meal: RecipesList
    var time: Int
    
    init(meal: RecipesList = RecipesList(), time: Int = 1) {
        self.meal = meal
        self.time = time
    }
}

// Main view model
class Model: ObservableObject {
    let meal: [RecipesList] = [
        RecipesList(
            recipeName: "Tomato Pasta",
            ingredients: "80g pennette pasta, 150g fresh tomatos, 1 tablespoon of olive oil, 1 garlic clove, 2 pinches of salt, few basil leaves, grated parmesan cheese",
            numberOfSteps: 10,
            imageName: "pasta",
            difficulty: "Easy",
            timeToCook: 20,
            calories: 500,
            servings: 1,
            vegetarian: true,
            steps: [
                RecipeStep(
                    step: "1. Boil the water",
                    imageName: "pasta",
                    description: """
                    Let’s begin with the Tomato Pasta Recipe.

                    Choose a pot that is appropriate for the amount of water you want to boil.
                    
                    Place it on the stove, ensuring it sits flat and securely. Set the burner to a high heat setting and let’s wait for the water to boil.
                    
                    When you will hear bubbles, it means we’re ready to move on the next step.
                    
                    When you are ready, say ‘Tap Next Step’.’
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "2. Cook the pasta",
                    imageName: "patate",
                    description: """
                    Now that the water is boiling, let’s cook the pasta. Pennette Pasta will take 10 minutes to cook, I will help you with a Timer.
                    
                    Take 80g of pennette pasta and carefully put it into the water.
                    
                    When you did, say ‘Tap Start Timer’ and I will start the timer.
                    
                    I will update you every minute with the time left. 
                    """,
                    speakSteps: "",
                    usesTimer: true,
                    timerTime: 600
                ),
                
                RecipeStep(
                    step: "3. Drain the pasta",
                    imageName: "pasta",
                    description: """
                    Now it’s time to drain the pasta! You can use a colander to do it and you can put the pasta on the side, we will need it later. 
                    
                    Once you’ve done it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "4. Start preparing the Tomato Sauce",
                    imageName: "pasta",
                    description: """
                    Now it’s time to prepare the Tomato Sauce. We will need a large pan, so let’s carefully put it on the stove without opening the heat yet. 
                    
                    When you did, say ‘Tap Next Step’ to continue.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "5. Start preparing the Tomato Sauce",
                    imageName: "pasta",
                    description: """
                    You can now add a tablespoon of olive oil and one clove of garlic in the pan. You can cut the garlic into smaller pieces if you wish.
                    
                    When you’re ready to move on the next step, say ‘Tap Next Step’.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "6. Start preparing the Tomato Sauce",
                    imageName: "pasta",
                    description: """
                    When the olive oil and garlic is in the pan, let’s set the burner to medium heat and wait for the olive oil to get hot. I will help you with a Timer of 2 minutes.
                    
                    You can say ‘Tap Start Timer’ to start it. I will update you every minute.
                    """,
                    speakSteps: "",
                    usesTimer: true,
                    timerTime: 120
                ),
                
                RecipeStep(
                    step: "7. Start preparing the Tomato Sauce",
                    imageName: "pasta",
                    description: """
                    Now that the oil is hot, let’s add fresh tomatoes in the pan. You can cut each one of them in 3-4 slices if you prefer.
                    
                    Once you did it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "8. Mixing and cooking the tomato",
                    imageName: "pasta",
                    description: """
                    Now it’s time to wait for the tomato to cook! I will help you with a 3 minutes Timer.
                    
                    When you’re ready, say ‘Tap Start Timer’. I will update you every minute. When I do, you can gently mix the tomatoes in the pan.
                    """,
                    speakSteps: "",
                    usesTimer: true,
                    timerTime: 180
                ),
                
                RecipeStep(
                    step: "9. Putting the pasta in",
                    imageName: "pasta",
                    description: """
                    While the burner is still going, let’s add the pasta in the pan and gently mixing it with the tomatoes.
                    I will help you with a 2 minute timer, it will be enough for the tomato sauce to mix with the pasta and for the pasta to heat up again.
                    
                    When you’re ready, say ‘Tap Start Timer’. 
                    I will update you every minute. Whenever I update you, you can give it a gentle mix.
                    """,
                    speakSteps: "",
                    usesTimer: true,
                    timerTime: 120
                ),
                
                RecipeStep(
                    step: "10. Putting the pasta in",
                    imageName: "pasta",
                    description: """
                    We’re done! We can now add few basil leaves as a final touch, then, you can put the pasta in a plate and enjoy it!
                    
                    Say ‘Complete Recipe’ to finish the process!
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        ),
        
        RecipesList(
            recipeName: "Salad",
            ingredients: "salsiccia, friarielli",
            numberOfSteps: 4,
            imageName: "pizza",
            difficulty: "Medium",
            timeToCook: 8,
            glutenFree: true,
            steps: [
                RecipeStep(
                    step: "1. Preparare la pasta",
                    imageName: "pasta",
                    description: """
                    Let’s gather all the ingredients and place them on a clean, accessible table. When you’re ready with everything on the table, say ‘ready.’

                    Ingredients:
                    • 2 Heck 97% Sausages
                    • 1 260g Neapolitan Dough ball
                    • 80g Fior Di Latte Mozzarella
                    • 10g Smoked Mozzarella (scamorza)
                    • A pinch of grated Hard Cheese
                    • 2 handfuls of cooked Friarielli
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: """
                    Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: """
                    Meanwhile, heat olive oil in a large skillet or pan, ensuring there is enough to cover the bottom of the pan. Sauté garlic until opaque but not browned. Stir in tomato paste. Immediately stir in the tomatoes, salt, and pepper. Reduce heat, and simmer until pasta is ready, adding basil at the end.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "4. Combinare la pasta e la salsa",
                    imageName: "pasta",
                    description: """
                    Drain pasta; do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce.
                    """,
                    speakSteps: "",
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        ),
    ]
    
    @Published var mealPage = MealPageModel()
    @Published var displayingMealPage = false
    @Published var followNavigationLink = false
    
    @Published var displayTabBar = true
    @Published var tabBarChanged = true
    @Published var tabViewSelectedIndex = Int.max {
        didSet {
            tabBarChanged = true
        }
    }
}

public func FormatTimeRemaining(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}

public func SpeakMessage(str: String, speechSynthesizer: AVSpeechSynthesizer) {
    let voice = AVSpeechSynthesisVoice(language: "en-US")
    let msgUtterance = AVSpeechUtterance(string: str)
    msgUtterance.voice = voice
    speechSynthesizer.speak(msgUtterance)
}
