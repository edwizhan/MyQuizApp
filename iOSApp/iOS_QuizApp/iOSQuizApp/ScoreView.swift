//
//  ScoreView.swift
//  
//
//  Created by Edwin Zhang.
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var navigateToWelcomeView: Bool = false
    @State private var animateProgress: Bool = false

    var body: some View {
        
        VStack {
            Text("Your Score:")
                .font(.largeTitle)
                .foregroundColor(Color(hex: "#0077cc"))
                .padding(.vertical, 24)
                .fontWeight(.bold)
            
        ZStack {
            RingView(scorePercentage: Double(quizViewModel.scorePercentage), lineWidth: 16, color: Color(hex: "#0077cc"), animateProgress: animateProgress)
                                .frame(width: 180, height: 180)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            animateProgress = true
                                        }
                                    }
                                }

            Text("\(quizViewModel.scorePercentage)%")
                .font(.largeTitle)
                .foregroundColor(Color(hex: "#0077cc"))
                .fontWeight(.bold)
            }
                .padding(.vertical, 16)
            
            Text("Thanks for playing!")
                .font(.title2)
                .padding()
                .offset(y: 16)
            
            Button(action: {
                quizViewModel.resetQuiz()
                navigateToWelcomeView = true
            }) {
                Text("Start Another Quiz")
                    .font(.title2)
                    .padding()
                    .background(Color(hex: "#0077cc"))
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .background(
            NavigationLink("",
                destination: WelcomeScreenView(),
                isActive: $navigateToWelcomeView)
        )
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

    
struct ScoreView_Previews: PreviewProvider {
    @State static private var navPath = NavigationPath()
    static var previews: some View {
        ScoreView(quizViewModel: QuizViewModel())
    }
}


