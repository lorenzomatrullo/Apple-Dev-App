import Foundation
import SwiftUI
import AVFoundation

struct StepPageView: View {
    @EnvironmentObject var model: Model
    private var meal: RecipesList
    
    // Timer-related variables
    @State private var timeRemaining = 10                 // Time left
    @State private var timerStarted = false               // If timer has started
    @State private var isTimerRunning = false             // If timer is currently running
    @State private var isTimerPaused = false              // If timer is currently paused
    @State private var isTimeUp = false                   // If timer is up
    @State private var repeatTimeInterval = 5
    @State private var repeatTimeCount = 0
    @State private var introSpoken = false                // If intro has been spoken

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Keep track of the current progress
    @State private var cookingState = CookingState(currentStep: 0)
    
    init(_ meal: RecipesList) {
        self.meal = meal
        cookingState.currentStep = 0
    }
    
    var body: some View {
        VStack(alignment: .center) {
            recipeTitle
            recipeImage
            
            Spacer().frame(height: 20)
            
            stepInfo
            stepDescription
            
            Spacer()
            
            navigationButtons
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden() // Hide the back button
        .navigationBarItems(trailing: helpAndRepeatButtons)
        .onAppear(perform: handleOnAppear)
        .onChange(of: cookingState.currentStep, perform: handleStepChange)
    }
    
    private var recipeTitle: some View {
        Text(meal.recipeName)
            .font(.title)
            .bold()
            .padding(.top, 10)
    }
    
    private var recipeImage: some View {
        Image(meal.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 175, height: 175)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var stepInfo: some View {
        Text("Step \(cookingState.currentStep + 1) of \(meal.numberOfSteps)")
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 5)
            .padding(.vertical, 10)
    }
    
    private var stepDescription: some View {
        ScrollView {
            VStack {
                Text(meal.steps[cookingState.currentStep].description)
                    .padding(.bottom, 10)
                
                if meal.steps[cookingState.currentStep].usesTimer {
                    timerView
                }
            }
        }
    }
    
    private var timerView: some View {
        Text(FormatTimeRemaining(timeRemaining))
            .onReceive(timer) { _ in handleTimerTick() }
            .foregroundColor(.blue)
            .font(.system(size: 60)) // Set to desired size
        
        // Timer controls
        return Group {
            if !timerStarted && !isTimeUp {
                startTimerButton
            } else if timerStarted && isTimerRunning && !isTimeUp {
                pauseTimerButton
            } else if timerStarted && isTimerPaused {
                resumeAndRestartButtons
            }
            
            if isTimeUp {
                timeUpMessage
            }
        }
    }
    
    private var startTimerButton: some View {
        Button {
            timerStarted = true
            isTimerRunning = true
            SpeakMessage(str: "Timer started!", speechSynthesizer: synth)
        } label: {
            Text("Start!")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.body)
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(5)
        }
        .accessibilityInputLabels(["start the timer, start, start timer"])
    }
    
    private var pauseTimerButton: some View {
        Button {
            isTimerRunning = false
            isTimerPaused = true
            SpeakMessage(str: "Timer paused!", speechSynthesizer: synth)
        } label: {
            Text("Pause")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.body)
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
    
    private var resumeAndRestartButtons: some View {
        HStack {
            Button {
                isTimerRunning = true
                isTimerPaused = false
                SpeakMessage(str: "Timer resumed!", speechSynthesizer: synth)
            } label: {
                Text("Resume")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .font(.body)
                    .background(Color.green.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            Button {
                resetTimer()
            } label: {
                Text("Restart")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .font(.body)
                    .background(Color.red.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
    }
    
    private var timeUpMessage: some View {
        Text("Time is up!")
            .font(.system(size: 40))
            .onAppear {
                SpeakMessage(str: "Time is up!", speechSynthesizer: synth)
            }
    }
    
    private var navigationButtons: some View {
        HStack {
            if cookingState.currentStep > 0 {
                previousStepButton
            }
            
            if cookingState.currentStep < meal.numberOfSteps - 1 {
                nextStepButton
            } else if cookingState.currentStep == meal.numberOfSteps - 1 {
                completeButton
            }
        }
    }
    
    private var previousStepButton: some View {
        Button {
            cookingState.currentStep -= 1
        } label: {
            Text("Previous Step")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.body)
                .background(Color.blue.opacity(0.7))
        }
        .buttonStyle(.borderedProminent)
        .accessibilityInputLabels(["Previous", "Previous Step"])
    }
    
    private var nextStepButton: some View {
        Button {
            cookingState.currentStep += 1
        } label: {
            Text("Next Step")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.body)
                .background(Color.blue.opacity(0.7))
        }
        .buttonStyle(.borderedProminent)
        .accessibilityInputLabels(["next, next step"])
    }
    
    private var completeButton: some View {
        Button {
            // Complete action can be implemented here
        } label: {
            Text("Complete")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .font(.body)
                .background(Color.blue.opacity(0.7))
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var helpAndRepeatButtons: some View {
        HStack {
            helpButton
            repeatButton
        }
    }
    
    private var helpButton: some View {
        Button(action: {
            HelpButtonPressed(status: HelpButtonState.MEAL_PAGE, synth: synth, meal: meal, cookingState: nil)
        }) {
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
    }
    
    private var repeatButton: some View {
        Button(action: {
            SpeakMessage(str: "We are at step \(cookingState.currentStep + 1) of \(meal.numberOfSteps).", speechSynthesizer: synth)
            SpeakMessage(str: meal.steps[cookingState.currentStep].speakSteps, speechSynthesizer: synth)
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
    }
    
    private func handleOnAppear() {
        if !introSpoken {
            synth.stopSpeaking(at: .immediate)
            SpeakMessage(str: "We are at step \(cookingState.currentStep + 1) of \(meal.numberOfSteps). " + meal.steps[cookingState.currentStep].speakSteps, speechSynthesizer: synth)
            introSpoken = true
        }
    }
    
    private func handleStepChange(newStep: Int) {
        synth.stopSpeaking(at: .immediate)
        SpeakMessage(str: "We are at step \(newStep + 1) of \(meal.numberOfSteps).", speechSynthesizer: synth)
        SpeakMessage(str: meal.steps[newStep].speakSteps, speechSynthesizer: synth)

        if meal.steps[newStep].usesTimer {
            timeRemaining = meal.steps[newStep].timerTime
            isTimerRunning = false
            timerStarted = false
            isTimeUp = false
            repeatTimeCount = 0
        } else {
            resetTimer()
        }
    }
 
    private func handleTimerTick() {
        if timerStarted && isTimerRunning && timeRemaining > 0 {
            // Timer decrement
            timeRemaining -= 1
            repeatTimeCount += 1
            
            // Check if time is up
            if timeRemaining == 0 {
                isTimeUp = true
            } else if repeatTimeCount >= repeatTimeInterval {
                let remainingMinutes = timeRemaining / 60
                let remainingSeconds = timeRemaining % 60
                
                if remainingMinutes > 0 {
                    SpeakMessage(str: "Time left: \(remainingMinutes) minutes and \(remainingSeconds) seconds", speechSynthesizer: synth)
                } else {
                    SpeakMessage(str: "Time left: \(remainingSeconds) seconds", speechSynthesizer: synth)
                }
                repeatTimeCount = 0
            }
        }
    }
    
    private func resetTimer() {
        timerStarted = false
        isTimerRunning = false
        isTimerPaused = false
        timeRemaining = meal.steps[cookingState.currentStep].timerTime
        repeatTimeCount = 0
        SpeakMessage(str: "Timer stopped! Say Start to start a new timer.", speechSynthesizer: synth)
    }
}

struct StepPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = RecipesList(
            recipeName: "Pasta",
            ingredients: "patate, provola",
            numberOfSteps: 4,
            imageName: "pasta",
            steps: [
                RecipeStep(
                    step: "1. Preparare la pasta",
                    imageName: "pasta",
                    description: """
                    Let’s gather all the ingredients and place them on a clean, accessible table. When you’re ready with everything on the table, say ‘ready.’
                    
                    Ingredients:
                    • Olive oil
                    • Garlic
                    • Canned tomato sauce
                    • Salt
                    • Pepper
                    • Fresh basil leaves (optional)
                    • Pasta (spaghetti, penne, or your choice)
                    • Grated Parmesan or Pecorino cheese (optional)
                    """,
                    speakSteps: """
                    Hello
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: "Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces.",
                    speakSteps: """
                    Hello
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "For this step we need a timer, so you can see how long it takes to cook the pasta. Say 'START' when you're ready to cook the pasta.",
                    speakSteps: """
                    Hello
                    """,
                    usesTimer: true,
                    timerTime: 30
                ),
                
                RecipeStep(
                    step: "4. Cuocere la pasta",
                    imageName: "pasta",
                    description: "Drain pasta, do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce.",
                    speakSteps: """
                    Hello
                    """,
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        )
        StepPageView(sampleMeal).environmentObject(Model())
    }
}
