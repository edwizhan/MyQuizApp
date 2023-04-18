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

    private var progress: Float {
        Float(quizViewModel.currentQuestionIndex + 1) / Float(quizViewModel.questions.count)
    }

    
    var body: some View {

        VStack {
            if !quizViewModel.questions.isEmpty {
                // Progress bar
                ProgressView(value: progress)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#0077cc")))
                // Display the question and answer choices
                Text(quizViewModel.currentQuestion.text)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                // Display the answer choices
                ForEach(quizViewModel.currentQuestion.choices) { choice in
                    Button(action: {
                        //withAnimation(.easeInOut(duration: 0.2)) {
                            selectedAnswer = choice.id
                        //}
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
                }
                .padding(.horizontal)
                
                VStack{
                    Button(action: {
                        withAnimation(nil){
                            if let selectedAnswer = selectedAnswer {
                                quizViewModel.submitAnswer(id: selectedAnswer)
                                self.selectedAnswer = nil
                                
                                if quizViewModel.isQuizFinished {
                                    navigateToScoreView.toggle()
                                }
                            }
                        }
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


