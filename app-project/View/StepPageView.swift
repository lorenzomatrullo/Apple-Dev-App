import Foundation
import SwiftUI
import AVFoundation

struct StepPageView: View {
    @EnvironmentObject var model: Model
    private var meal: RecipesList
    
    // Timer-related variables
    @State var timeRemaining = 10                // time left
    @State var timerStarted: Bool = false        // if timer has started
    @State var isTimerRunning: Bool = false      // if timer is currently running
    @State var isTimerPaused: Bool = false       // if timer is currently paused
    @State var isTimeUp: Bool = false            // if timer is up
    @State var repeatTimeInterval: Int = 60
    @State var repeatTimeCount: Int = 0
    @State var introSpoken: Bool = false         // if timer is up

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Keep track of the current progress
    @State private var cookingState = CookingState(currentStep: 0)
    
    init(_ meal: RecipesList) {
        self.meal = meal
        cookingState.currentStep = 0
    }
    
    private var exitButton: some View {
        Button(action: {
            hasExitedFromStepView = true
            // Dismiss the current view and go back to FirstPageView
            presentationMode.wrappedValue.dismiss()
            

        }) {
            Text("Exit")
                .font(.system(size: 14))
                .bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 18)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.2), lineWidth: 2)
                )
        }
        .accessibilityLabel("Exit")
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
                    
                    // Add timer if needed for this step
                    if meal.steps[cookingState.currentStep].usesTimer {
                        
                        Button {
                            timeRemaining += 60
                            
                            let remainingMinutes = timeRemaining / 60
                            let remainingSeconds = timeRemaining % 60
                            
                            if remainingMinutes > 0 {
                                SpeakMessage(str: "Timer updated to: \(remainingMinutes) minutes and \(remainingSeconds) seconds", speechSynthesizer: synth)
                            } else {
                                SpeakMessage(str: "Timer updated to: \(remainingSeconds) seconds", speechSynthesizer: synth)
                            }
                        } label: {
                            Text("Add One Minute")
                                .hidden()
                        }
                        .accessibilityInputLabels(["Add One Minute"])
                        
                        Button {
                            timeRemaining -= 60
                            
                            if(timeRemaining < 0) {
                                timeRemaining = 0
                                isTimeUp = true
                            }
                            
                            let remainingMinutes = timeRemaining / 60
                            let remainingSeconds = timeRemaining % 60
                            
                            if remainingMinutes > 0 {
                                SpeakMessage(str: "Timer updated to: \(remainingMinutes) minutes and \(remainingSeconds) seconds", speechSynthesizer: synth)
                            } else {
                                SpeakMessage(str: "Timer updated to: \(remainingSeconds) seconds", speechSynthesizer: synth)
                            }
                        } label: {
                            Text("Subtract One Minute")
                                .hidden()
                        }
                        .accessibilityInputLabels(["Subtract One Minute"])
                        
                        Text(FormatTimeRemaining(timeRemaining))
                            .onReceive(timer) { _ in
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
                            .foregroundColor(.blue)
                            .font(.system(size: 60)) // Set to desired size
                        
                        // Timer controls
                        if !timerStarted && !isTimeUp {
                            Button {
                                timerStarted = true
                                isTimerRunning = true
                                SpeakMessage(str: "Timer started!", speechSynthesizer: synth)
                            } label: {
                                Text("Start")
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .font(.body)
                                    .background(Color.blue.opacity(0.7))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                            .accessibilityInputLabels(["Start"])
                        } else if timerStarted && isTimerRunning && !isTimeUp {
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
                        } else if timerStarted && isTimerPaused {
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
                                    timerStarted = false
                                    isTimerRunning = false
                                    isTimerPaused = false
                                    timeRemaining = meal.steps[cookingState.currentStep].timerTime
                                    repeatTimeCount = 0
                                    SpeakMessage(str: "Timer stopped! Say Start to start a new timer.", speechSynthesizer: synth)
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
                                
                        // If time is up, show the text and speak the message
                        if isTimeUp {
                            Text("Time is up!")
                                .font(.system(size: 40))
                                .onAppear {
                                    SpeakMessage(str: meal.steps[cookingState.currentStep].afterTimerText, speechSynthesizer: synth)
                                }
                        }
                    }
                }
            }

            Spacer()
            
            // HStack for navigation buttons
            HStack {
                if cookingState.currentStep > 0 {
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
                }
                
                // Button to progress to the next step
                if cookingState.currentStep < meal.numberOfSteps - 1 {
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
                } else if cookingState.currentStep == meal.numberOfSteps - 1 {
                    Button {
                        hasExitedFromStepView = true
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Complete")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .font(.body)
                            .background(Color.blue.opacity(0.7))
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden() //to hide the back button
        .navigationBarItems(leading: exitButton, trailing: HStack {
            // Help Button
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

            // Repeat button
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
        })
        .onAppear {
            if !introSpoken {
                synth.stopSpeaking(at: .immediate)
                SpeakMessage(str: "We are at step \(cookingState.currentStep + 1) of \(meal.numberOfSteps). " + meal.steps[cookingState.currentStep].speakSteps, speechSynthesizer: synth)
                introSpoken = true
            }
        }
        .onChange(of: cookingState.currentStep) { newStep in
            synth.stopSpeaking(at: .immediate)
            SpeakMessage(str: "We are at step \(cookingState.currentStep + 1) of \(meal.numberOfSteps).", speechSynthesizer: synth)
            SpeakMessage(str: meal.steps[cookingState.currentStep].speakSteps, speechSynthesizer: synth)

            if meal.steps[newStep].usesTimer {
                timeRemaining = meal.steps[newStep].timerTime
                isTimerRunning = false
                timerStarted = false
                isTimeUp = false
                repeatTimeCount = 0
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
