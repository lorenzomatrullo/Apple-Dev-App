import Foundation
import SwiftUI
import AVFoundation

struct StepPageView: View {
    @EnvironmentObject var model: Model
    
    private var meal: RecipesList
    
    // Timer-related variables
    @State var timeRemaining = 10               // time left
    @State var timerStarted: Bool = false       // if timer has started
    @State var isTimerRunning: Bool = false     // if timer is currently running
    @State var isTimerPaused : Bool = false     // if timer is currently paused
    @State var isTimeUp: Bool = false           // if timer is up
    @State var repeatTimeInterval : Int = 5
    @State var repeatTimeCount: Int = 0
    
    public let synth = AVSpeechSynthesizer()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
      
    // Keep track of the current progress
    @State private var cookingState = CookingState(currentStep: 0)
    

    init(_ meal: RecipesList) {
        self.meal = meal
    }
    
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text(meal.recipeName)
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            // Display the recipe image
            Image(meal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 175)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                

            // Add some space
            Spacer().frame(height: 20)

            // Display the current step information
            Text("Step \(cookingState.currentStep + 1) of \(meal.numberOfSteps)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 5)
                .padding(.vertical, 10)

            // Step description
            ScrollView {
                VStack {
                    Text("\(meal.steps[cookingState.currentStep].description)")
                        .padding(.bottom, 10)
                    
                    // Add timer in case it's needed for this step
                    if meal.steps[cookingState.currentStep].usesTimer {
                        Text(FormatTimeRemaining(timeRemaining))
                            .onReceive(timer) { _ in
                                if timerStarted && isTimerRunning && timeRemaining > 0 {
                                    
                                    // Timer decrement
                                    timeRemaining -= 1
                                    
                                    repeatTimeCount += 1;
                                    
                                    // Check if time is up
                                    if(timeRemaining == 0){
                                        isTimeUp = true
                                    }
                                    else
                                    {
                                        if(repeatTimeCount >= repeatTimeInterval) {
                                            // Read the time left aloud
                                            let remainingMinutes = timeRemaining / 60
                                            let remainingSeconds = timeRemaining % 60
                                            
                                            if(remainingMinutes > 0) {
                                                SpeakMessage(str: "Time left: \(remainingMinutes) minutes and \(remainingSeconds) seconds", speechSynthesizer: synth)
                                            }
                                            else {
                                                SpeakMessage(str: "Time left: \(remainingSeconds) seconds", speechSynthesizer: synth)
                                            }
                                                
                                            
                                            repeatTimeCount = 0;
                                        }
                                    }
                                }
                            }
                            .foregroundColor(.blue)
                            .font(.system(size: 60)) // Set to desired size
                        
                        // only if timer hasn't started, show the start button
                        if(!timerStarted && !isTimeUp) {
                            Button {
                                timerStarted = true
                                isTimerRunning = true
                                SpeakMessage(str: "Timer started!", speechSynthesizer: synth)
                            } label: {
                                Text("Start!")
                                    .padding(.horizontal, 10) // Adjust horizontal padding
                                    .padding(.vertical, 5)     // Adjust vertical padding
                                    .font(.body)               // Change font size if needed
                                    .background(Color.blue.opacity(0.7))
                                    .foregroundColor(.white) // Change text color if needed
                                    .cornerRadius(5)
                            }
                        }
                        else if(timerStarted && isTimerRunning && !isTimeUp) {
                            Button {
                                isTimerRunning = false
                                isTimerPaused = true
                                SpeakMessage(str: "Timer paused!", speechSynthesizer: synth)
                            } label: {
                                Text("Pause")
                                    .padding(.horizontal, 10) // Adjust horizontal padding
                                    .padding(.vertical, 5)     // Adjust vertical padding
                                    .font(.body)               // Change font size if needed
                                    .background(Color.red.opacity(0.7))
                                    .foregroundColor(.white) // Change text color if needed
                                    .cornerRadius(5)
                            }
                        }
                        else if(timerStarted && isTimerPaused) {
                            HStack {
                                Button {
                                    isTimerRunning = true
                                    isTimerPaused = false
                                    SpeakMessage(str: "Timer resumed!", speechSynthesizer: synth)
                                } label: {
                                    Text("Resume")
                                        .padding(.horizontal, 10) // Adjust horizontal padding
                                        .padding(.vertical, 5)     // Adjust vertical padding
                                        .font(.body)               // Change font size if needed
                                        .background(Color.green.opacity(0.7))
                                        .foregroundColor(.white) // Change text color if needed
                                        .cornerRadius(5)
                                    
                                }
                                
                                Button {
                                    timerStarted = false
                                    isTimerRunning = false
                                    isTimerPaused = false
                                    timeRemaining = meal.steps[cookingState.currentStep].timerTime
                                    repeatTimeCount = 0
                                    SpeakMessage(str: "Timer stopped! Say Start to start a new timer.", speechSynthesizer: synth)
                                } label: {
                                    Text("Restart")
                                        .padding(.horizontal, 10) // Adjust horizontal padding
                                        .padding(.vertical, 5)     // Adjust vertical padding
                                        .font(.body)               // Change font size if needed
                                        .background(Color.red.opacity(0.7))
                                        .foregroundColor(.white) // Change text color if needed
                                        .cornerRadius(5)
                                }
                            }
                        }
                                
                        // If time is up, show the text and speak the message
                        if(isTimeUp)
                        {
                            Text("Time is up!")
                                .font(.system(size: 40))
                                .onAppear()
                                {
                                    SpeakMessage(str : "Time is up!", speechSynthesizer: synth)
                                }
                        }
                    }
                }
            }
            
            

            Spacer()
            
            // HStack for navigation buttons
            HStack {
                if(cookingState.currentStep > 0) {
                    // Button to return to the previous step
                    Button {
                        if cookingState.currentStep > 0 {
                            cookingState.currentStep -= 1
                        }
                    } label: {
                        Text("Previous Step")
                            .padding(.horizontal, 10) // Adjust horizontal padding
                            .padding(.vertical, 5)     // Adjust vertical padding
                            .font(.body)               // Change font size if needed
                            .background(Color.blue.opacity(0.7))
                    }.buttonStyle(.borderedProminent)
                }
                
                // Button to progress to the next step
                if(cookingState.currentStep < meal.numberOfSteps - 1) {
                    Button {
                        if cookingState.currentStep < meal.numberOfSteps - 1 {
                            cookingState.currentStep += 1
                        }
                    } label: {
                        Text("Next Step")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.body)
                            .background(Color.blue.opacity(0.7))
                    }.buttonStyle(.borderedProminent)
                }
                // If it's the final step, we want another button with another function call instead of the 'Next Step' one
                else if cookingState.currentStep == meal.numberOfSteps - 1 {
                    Button {
                        
                    } label: {
                        Text("Complete")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.body)
                            .background(Color.blue.opacity(0.7))
                    }.buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {
                    // Action for the help button
                    HelpButtonPressed(status: HelpButtonState.STEP_PAGE, synth: synth, meal: meal, cookingState: cookingState)
                }) {
                    Text("?")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44) // Size of the button
                        .background(Color.red)
                        .clipShape(Circle()) // Makes the button circular
                        .shadow(radius: 5) // Optional shadow
                })
        .onChange(of: cookingState.currentStep) { newStep in
                    if meal.steps[newStep].usesTimer {
                        timeRemaining = meal.steps[newStep].timerTime
                        isTimerRunning = false
                        timerStarted = false
                        isTimeUp = false
                        repeatTimeCount = 0;
                    } else {
                        timeRemaining = 0
                        isTimerRunning = false
                        timerStarted = false
                        isTimeUp = false
                        repeatTimeCount = 0
                    }
                }
    }
}


struct StepPage_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeal = RecipesList(
            recipeName: "Pasta",
            ingredients: "patate, provola",
            numberOfSteps: 4,
            imageName: "pasta",
            steps:
                [
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
                    usesTimer: false,
                    timerTime: 0),
                
                RecipeStep(
                    step: "2. Preparare le patate",
                    imageName: "patate",
                    description: "Place tomatoes in a large pot and cover with cold water. Bring just to a boil. Pour off water, and cover again with cold water. Peel the skin off tomatoes and cut into small pieces.",
                    usesTimer: false,
                    timerTime: 0
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "For this step we need a timer, so you can see how long it takes to cook the pasta. Say 'START' when you're ready to cook the pasta.",
                    usesTimer: true,
                    timerTime: 30
                ),
                
                RecipeStep(
                    step: "3. Cuocere la pasta",
                    imageName: "pasta",
                    description: "Drain pasta, do not rinse in cold water. Toss with a bit of olive oil, then mix into the sauce.",
                    usesTimer: false,
                    timerTime: 0
                ),
            ]
        )
        StepPageView(sampleMeal).environmentObject(Model())
    }
}
