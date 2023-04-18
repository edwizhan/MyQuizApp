//
//  WelcomeScreenView.swift
//  
//
//  Created by Edwin Zhang.
//

import SwiftUI

struct WelcomeScreenView: View {
    @StateObject private var quizViewModel = QuizViewModel()

    var body: some View {
        VStack {
            if quizViewModel.isLoading {
                ActivityIndicator()
            } else {
                Text("Welcome to the Coding Quiz Game!")
                    .font(.system(size:46))
                    .multilineTextAlignment(.center)
                    .offset(y: -48)
                    .fontWeight(.bold)
                
                NavigationLink(destination: QuizView(quizViewModel: quizViewModel)) {
                    Text("Start Quiz")
                        .font(.title2)
                        .padding(.horizontal, 32.0)
                        .padding(.vertical, 16.0)
                        .background(Color(hex: "#0077cc"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }.onAppear{quizViewModel.resetQuiz()}
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}

