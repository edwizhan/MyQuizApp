//
//  QuizViewModel.swift
//  
//
//  Created by Edwin Zhang.
//

import Foundation
import SwiftUI
import Combine

struct Question {
    let id: Int
    let text: String
    let choices: [Choice]
    let correctAnswer: String
    
    static func fromFirestoreData(id: String, data: [String: Any]) -> Question? {
            guard let text = data["text"] as? String,
                  let choicesData = data["choices"] as? [[String: Any]],
                  let correctAnswer = data["correctAnswer"] as? String else {
                return nil
            }
            
            let choices = choicesData.compactMap { choiceData -> Choice? in
                guard let id = choiceData["id"] as? String,
                      let text = choiceData["text"] as? String else {
                    return nil
                }
                return Choice(id: id, text: text)
            }
            
            return Question(id: Int(id) ?? 0, text: text, choices: choices, correctAnswer: correctAnswer)
        }
}

struct Choice: Identifiable {
    let id: String
    let text: String
}

class QuizViewModel: ObservableObject {
    let questionsRepository = QuestionsRepository()
    @Published private(set) var questions: [Question] = []
    @Published private(set) var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
        
    init() {
        questionsRepository.$questions
            .receive(on: DispatchQueue.main)
            .assign(to: \.questions, on: self)
            .store(in: &cancellables)
            
        questionsRepository.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
    }
    
    /*
    @Published private(set) var questions: [Question] = [
        Question(
            id: 1,
            text: "What is the main programming language used for machine learning?",
            choices: [
                Choice(id: "a", text: "JavaScript"),
                Choice(id: "b", text: "Python"),
                Choice(id: "c", text: "Swift"),
                Choice(id: "d", text: "Kotlin")
            ],
            correctAnswer: "b"
        ),
        Question(
            id: 2,
            text: "Which term refers to the process of automatically installing and managing a project's dependencies?",
            choices: [
                Choice(id: "a", text: "dependency injection"),
                Choice(id: "b", text: "package management"),
                Choice(id: "c", text: "build automation"),
                Choice(id: "d", text: "version control")
            ],
            correctAnswer: "b"
        ),
        Question(
            id: 3,
            text: "Which term refers to a collection of pre-written code that can be used to perform common tasks?",
            choices: [
                Choice(id: "a", text: "library"),
                Choice(id: "b", text: "variable"),
                Choice(id: "c", text: "function"),
                Choice(id: "d", text: "class")
            ],
            correctAnswer: "a"
        ),
        Question(
            id: 4,
            text: "Which programming language has 'console.log' command?",
            choices: [
                Choice(id: "a", text: "JavaScript"),
                Choice(id: "b", text: "Kotlin"),
                Choice(id: "c", text: "Swift"),
                Choice(id: "d", text: "Python")
            ],
            correctAnswer: "a"
        ),
        Question(
            id: 5,
            text: "Which term refers to the process of translating source code into machine code?",
            choices: [
                Choice(id: "a", text: "compilation"),
                Choice(id: "b", text: "interpretation"),
                Choice(id: "c", text: "execution"),
                Choice(id: "d", text: "debugging")
            ],
            correctAnswer: "a"
        )
    ]
    */
    
    @Published var isQuizFinished: Bool = false
    @Published var currentQuestionIndex: Int = 0
    private var numberOfCorrectAnswers: Int = 0
    
    var currentQuestion: Question {
            questions[currentQuestionIndex]
    }
        
    var scorePercentage: Int {
            Int(Double(numberOfCorrectAnswers) / Double(questions.count) * 100)
    }
        
    func submitAnswer(id: String) {
        if id == currentQuestion.correctAnswer {
            numberOfCorrectAnswers += 1
        }
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            isQuizFinished = true
        }
    }

    
    func checkIsFinished() {
        if currentQuestionIndex >= questions.count - 1 {
            isQuizFinished = true
        } else {
            isQuizFinished = false
        }
    }
        
    
    func handleSubmit(selectedAnswer: String) {
        submitAnswer(id: selectedAnswer)
        if isQuizFinished {
            // Do nothing, we will navigate to the ScoreView
        } else {
            loadNextQuestion()
        }
    }

    func loadNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func resetQuiz() {
        isQuizFinished = false
        currentQuestionIndex = 0
        numberOfCorrectAnswers = 0
        questionsRepository.fetchQuestions()
    }


}
