//
//  QuizView.swift
//  
//
//  Created by Edwin Zhang.
//

import SwiftUI
import UIKit

struct QuizView: View {
    @ObservedObject var quizViewModel: QuizViewModel
    @State private var selectedAnswer: String?
    @State private var navigateToScoreView: Bool = false
    @State private var showMessage: Bool = false
    @State private var message: String = ""

    private var progress: Float {
        Float(quizViewModel.currentQuestionIndex + 1) / Float(quizViewModel.questions.count)
    }

    private var messageColor: Color {
            message == "Correct!" ? Color(hex: "#028a0f") : Color(hex: "#fbb117")
    }
    
    private func handleSubmitAnswer() {
            if let selectedAnswer = selectedAnswer {
                let isCorrect: Bool = quizViewModel.submitAnswer(id: selectedAnswer)
                self.selectedAnswer = nil

                showMessage = true
                message = isCorrect ? "Correct!" : "Oops"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showMessage = false

                    if quizViewModel.isQuizFinished {
                        navigateToScoreView.toggle()
                    }
                }
            }
    }
    
    var body: some View {
        VStack {
            if !quizViewModel.questions.isEmpty {
                // Progress bar
                NewProgressView(value: progress, height: 10, tint: Color(hex: "#0077cc"))
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                // Display the question and answer choices
                Text(quizViewModel.currentQuestion.text)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                // Display the answer choices
                ForEach(quizViewModel.currentQuestion.choices) { choice in
                    Button(action: {
                            selectedAnswer = choice.id
                    }) {
                        Text(choice.text)
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(selectedAnswer == choice.id ? Color(hex: "#0077cc") : Color.white)
                            .foregroundColor(selectedAnswer == choice.id ? Color.white : Color.black)
                            .cornerRadius(6)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(selectedAnswer == choice.id ? Color(hex: "#0077cc") : Color.gray, lineWidth: 1))
                    }
                    .padding(.bottom, 6)
                    .disabled(showMessage)
                }
                .padding(.horizontal)
                
                
                VStack{
                    Button(action: {
                        handleSubmitAnswer()
                    }) {
                        Text("Submit Answer")
                            .font(.title2)
                            .padding()
                            .frame(width: 200, height: 52)
                            .background(selectedAnswer == nil ? Color.gray.opacity(0.5) : Color(hex: "#0077cc"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(selectedAnswer == nil)
                    .padding(.top, 4)
                }
                Spacer()
                
                if showMessage {
                    Text(message)
                        .font(.title2)
                        .bold()
                        .foregroundColor(messageColor)
                        .padding(.bottom, 60)
                }
            }
        }
        .background(NavigationLink("", destination: ScoreView(quizViewModel: quizViewModel), isActive: $navigateToScoreView))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
    
}
    
    struct QuizView_Previews: PreviewProvider {
        static var previews: some View {
            QuizView(quizViewModel: QuizViewModel())
        }
    }


