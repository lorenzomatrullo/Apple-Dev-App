import Foundation
import SwiftUI
import AVFoundation

public let synth = AVSpeechSynthesizer()
public var hasToAnnounceHomepage: Bool = false

public var hasExitedFromStepView : Bool = false
public var firstTimeOnHomepage : Bool = true

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
    
    init(
        recipeName: String = "",
        ingredients: String = "",
        numberOfSteps: Int = 0,
        imageName: String = "",
        difficulty: String = "",
        timeToCook: Int = 0,
        calories: Int = 0,
        servings: Int = 1,
        vegetarian: Bool = false,
        lactoseFree: Bool = false,
        glutenFree: Bool = false,
        steps: [RecipeStep] = []
    ) {
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
    let afterTimerText : String // when timer expires, we want to say some additional thing for each step, like "shut down the stove" after cooking pasta
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

public enum HelpButtonState {
    case HOME_PAGE
    case MEAL_PAGE
    case STEP_PAGE
}

// Main view model
class Model: ObservableObject {
    let meal: [RecipesList] = [
        RecipesList(
            recipeName: "Tomato Pasta",
            ingredients: "80g pennette pasta, 150g fresh tomatoes, 1 tablespoon of olive oil, 1 garlic clove, 2 pinches of salt, few basil leaves, grated parmesan cheese",
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
                    description: "Let's begin with the Tomato Pasta Recipe!",
                    speakSteps: """
                    Let’s begin with the Tomato Pasta Recipe.
                    
                    Choose a big  pot and pour it with water halfway.
                    Place it on the stove, ensuring it sits flat and securely. Set the burner to a high heat setting, and let’s wait for the water to boil.
                    When you will hear bubbles, it means we’re ready to move on the next step.
                    When you are ready, say ‘Tap Next Step’.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "2. Cook the pasta",
                    imageName: "patate",
                    description: "Now we cook the pasta.",
                    speakSteps: """
                    Now that the water is boiling, let’s cook the pasta. Pennette Pasta will take 10 minutes to cook, I will help you with a Timer.
                    
                    Take 80g of pennette pasta and carefully put it into the water.
                    
                    When you do, say ‘Tap Start’ and I will start the timer.
                    
                    I will update you every minute with the time left.
                    """,
                    usesTimer: true,
                    timerTime: 600,
                    afterTimerText: "Time is up! Let’s shut down the stove and carefully move the pot on the side. When you’re ready to drain the pasta, say ‘Tap Next Step’."
                ),
                RecipeStep(
                    step: "3. Drain the pasta",
                    imageName: "pasta",
                    description: "Now it's time to drain the pasta.",
                    speakSteps: """
                    Now it’s time to drain the pasta! You can use a colander to do it and put the pasta on the side; we will need it later.
                    
                    Once you’ve done it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "4. Start preparing the Tomato Sauce",
                    imageName: "pasta",
                    description: "Let's get the Tomato Sauce ready.",
                    speakSteps: """
                    Now it’s time to prepare the Tomato Sauce. We will need a large pan, so let’s carefully put it on the stove without opening the heat yet.
                    
                    When you do, say ‘Tap Next Step’ to continue.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "5. Add olive oil and garlic",
                    imageName: "pasta",
                    description: "Let's continue with the Tomato Sauce.",
                    speakSteps: """
                    You can now add a tablespoon of olive oil and one clove of garlic in the pan. You can cut the garlic into smaller pieces if you wish.
                    
                    When you’re ready to move on to the next step, say ‘Tap Next Step’.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "6. Cook the garlic",
                    imageName: "pasta",
                    description: "Let's cook the Tomato Sauce for 2 minutes!",
                    speakSteps: """
                    When the olive oil and garlic are in the pan, let’s set the burner to medium heat and wait for the olive oil to get hot. I will help you with a Timer of 2 minutes.
                    
                    You can say ‘Tap Start’ to start it. I will update you every minute.
                    """,
                    usesTimer: true,
                    timerTime: 120,
                    afterTimerText: "Time is up! We can move to the next step when you say, ‘Tap Next Step'."
                ),
                RecipeStep(
                    step: "7. Add tomatoes",
                    imageName: "pasta",
                    description: "Now it's time to add the tomatoes to the pan!",
                    speakSteps: """
                    Now that the oil is hot, let’s add fresh tomatoes to the pan. You can cut each one of them into 3-4 slices if you prefer.
                    
                    Once you do it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "8. Cook the tomatoes",
                    imageName: "pasta",
                    description: "Time to wait for the tomatoes to cook!",
                    speakSteps: """
                    Now it’s time to wait for the tomatoes to cook! I will help you with a 3-minute Timer.
                    
                    When you’re ready, say ‘Tap Start’. I will update you every minute. When I do, you can gently mix the tomatoes in the pan.
                    """,
                    usesTimer: true,
                    timerTime: 180,
                    afterTimerText: "Time is up! Say ‘Tap Next Step’ to continue. You should do it straight away as the burner is still going."
                ),
                RecipeStep(
                    step: "9. Add the pasta",
                    imageName: "pasta",
                    description: "Adding in the pasta!",
                    speakSteps: """
                    While the burner is still going, let’s add the pasta to the pan and gently mix it with the tomatoes.
                    
                    I will help you with a 2-minute timer; it will be enough for the tomato sauce to mix with the pasta and for the pasta to heat up again.
                    
                    When you’re ready, say ‘Tap Start’. 
                    I will update you every minute. Whenever I update you, you can give it a gentle mix.
                    """,
                    usesTimer: true,
                    timerTime: 120,
                    afterTimerText: "Time is up! You can shutdown the burner now. When you’re ready to move on, say ‘Tap Next Step’."
                ),
                RecipeStep(
                    step: "10. Time to plate!",
                    imageName: "pasta",
                    description: "Time to plate!",
                    speakSteps: """
                    We’re done! We can now add a few basil leaves as a final touch, then you can put the pasta on a plate and enjoy it!
                    
                    Say ‘Tap Complete’, or, 'Tap Exit', to finish the process!
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
            ]
        ),
        
        RecipesList(
            recipeName: "Tiramisu",
            ingredients: "1 cup of cooled strong brewed coffee, 1 tablespoon sugar, 1 cup mascarpone cheese, 1 cup heavy cream, a quarter cup powdered sugar, 1 teaspoon vanilla extract, 1 pack ladyfinger cookies (savoiardi), Unsweetened cocoa powder",
            numberOfSteps: 9,
            imageName: "tiramisu",
            difficulty: "Medium",
            timeToCook: 20,
            calories: 800,
            servings: 4,
            glutenFree: false,
            steps: [
                RecipeStep(
                    step: "1. Brew Coffee",
                    imageName: "tiramisu",
                    description: """
                    Let's brew some coffee!
                    """,
                    speakSteps: """
                    Brew 1 cup of strong coffee. Let it cool to room temperature. If you prefer, add 1 tablespoon of sugar to the coffee for sweetness and set it aside.
                    
                    Once you did it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "2. Make the Cream Mixture",
                    imageName: "tiramisu",
                    description: """
                    Now it's time to make the cream!
                    """,
                    speakSteps: """
                    In a mixing bowl, add 1 cup of mascarpone cheese, 1 cup of heavy cream, a quarter cup of powdered sugar, and 1 teaspoon of vanilla extract.
                    
                    Once you do it, say ‘Tap Next Step’ to move onto the next step.
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "3. Whip the Cream",
                    imageName: "tiramisu",
                    description: """
                    Now it's time to whip the cream!
                    """,
                    speakSteps: """
                    Use a hand mixer or whisk to mix the ingredients on medium speed until the cream thickens and holds soft peaks. I will help you with a 2-minute timer; it will be enough for the cream to not be too stiff.               
                    
                    When you’re ready, say ‘Tap Start’. 
                    I will update you every minute.
                    """,
                    usesTimer: true,
                    timerTime: 120,
                    afterTimerText: "Time is up! Say ‘Tap Next Step’ to move onto the next step"
                ),
                RecipeStep(
                    step: "4. Prepare the Ladyfingers",
                    imageName: "tiramisu",
                    description: """
                    It's time to prepare the ladyfingers!
                    """,
                    speakSteps: """
                    Dip each ladyfinger briefly into the cooled coffee. Don’t soak them—just a quick dip so they are moist but not soggy. Lay them in a 9 by 9-inch dish or a similar-sized serving dish.
                    
                    When you’re ready, say ‘Tap Next Step’ to move onto the next step. 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "5. Layer the Tiramisu",
                    imageName: "tiramisu",
                    description: """
                    Let's layer the whipped cream!
                    """,
                    speakSteps: """
                    Spread half of the whipped cream mixture over the layer of dipped ladyfingers. Use a spoon or spatula to spread it evenly.
                    
                    When you’re ready, say ‘Tap Next Step’ to move onto the next step. 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "6. Add Another Layer",
                    imageName: "tiramisu",
                    description: """
                    Add another layer.
                    """,
                    speakSteps: """
                    Add another layer of dipped ladyfingers on top of the cream. Make sure the cookies are aligned and cover the entire surface.
                    
                    When you’re ready, say ‘Tap Next Step’ to move onto the next step. 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "7. Top with Remaining Cream",
                    imageName: "tiramisu",
                    description: """
                    Top the new layer with the remaining cream.
                    """,
                    speakSteps: """
                    Spread the remaining whipped cream mixture over the second layer of ladyfingers. Smooth it out evenly with a spoon or spatula.
                    
                    When you’re ready, say ‘Tap Next Step’ to move onto the next step. 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "8. Chill the Tiramisu",
                    imageName: "tiramisu",
                    description: """
                    Chill the Tiramisu.
                    """,
                    speakSteps: """
                    Cover the dish with plastic wrap or a lid. Refrigerate the tiramisu for at least 4 hours (or overnight) to let it set.
                    
                    When you’re ready, say ‘Tap Next Step’ to move onto the next step. 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
                ),
                RecipeStep(
                    step: "9. Serve",
                    imageName: "tiramisu",
                    description: """
                    Time to serve!
                    """,
                    speakSteps: """
                    Before serving, dust the top of the tiramisu with a thin layer of unsweetened cocoa powder using a sifter or small mesh strainer. Serve chilled.
                    
                    We are done! Say ‘Tap Complete’, or, 'Tap Exit', to finish the process! 
                    """,
                    usesTimer: false,
                    timerTime: 0,
                    afterTimerText: ""
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
    msgUtterance.rate = 0.45
    msgUtterance.voice = voice
    speechSynthesizer.speak(msgUtterance)
}

public func HelpButtonPressed(status: HelpButtonState, synth: AVSpeechSynthesizer, meal: RecipesList?, cookingState: CookingState?) {
    switch status {
    case .HOME_PAGE:
        SpeakMessage(str: "You are currently in the 'Home Page'. You can say 'Tap Tomato Pasta' or 'Tap Salad' to get more information about the recipe.", speechSynthesizer: synth)
        
    case .MEAL_PAGE:
        if let meal = meal {
            SpeakMessage(str: "You are currently in the 'Meal Page' and you're viewing the recipe for \(meal.recipeName). You can say 'Tap Repeat' to read the recipe again. You can say 'Tap Start' to start cooking the recipe. You can say 'Tap Back' to go back to the 'Home Page'.", speechSynthesizer: synth)
        } else {
            debugPrint("Meal is nil")
        }
        
    case .STEP_PAGE:
        if let meal = meal, let cookingState = cookingState {
            SpeakMessage(str: "You are currently in the 'Step Page' for \(meal.recipeName). You are at Step \(cookingState.currentStep + 1) out of \(meal.numberOfSteps). You can say 'Tap Repeat' to read the step again. You can say 'Tap Next' to go to the next step. You can say 'Tap Previous' to go to the previous step. You can say 'Tap Exit' to stop cooking.", speechSynthesizer: synth)
        } else {
            debugPrint("Meal or cookingState is nil")
        }
    }
}
