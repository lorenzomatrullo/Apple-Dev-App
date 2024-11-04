import Foundation
import SwiftUI

struct AlertView: View {
    
    @State private var isShowingAlert = false
    @State private var navigateToFirstPage = false

    var body: some View {
        VStack {
            // Only show the button if we are not navigating to FirstPageView
            if !navigateToFirstPage {
                Button("") {
                    isShowingAlert = true
                }
                .alert("Voice Control", isPresented: $isShowingAlert) {
                    Button("OK", role: .cancel) {
                        navigateToFirstPage = true // Set the flag to navigate
                    }
                } message: {
                    Text("Enable voice control to proceed")
                }
            }
            
            // Conditional navigation to FirstPageView
            if navigateToFirstPage {
                FirstPageView()
                    .transition(.slide) // Optional transition for visual effect
            }
        }
        .onAppear {
            isShowingAlert = true // Show the alert when the view appears
            
            let authMessage = "Enable voice control to continue using the app. If you don't have it enabled yet, just say 'Hey Siri, enable voice control'. After that just say 'Tap Ok'"
            SpeakMessage(str: authMessage, speechSynthesizer: synth)
        }
    }
}

#Preview {
    AlertView()
}
