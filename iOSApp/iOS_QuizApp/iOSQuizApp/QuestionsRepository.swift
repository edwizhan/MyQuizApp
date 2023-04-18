//
//  QuestionsRepository.swift
//  
//
//  Created by Edwin Zhang.
//

import FirebaseFirestore
import Combine

class QuestionsRepository: ObservableObject {
    private let db = Firestore.firestore()
    @Published private(set) var questions: [Question] = []
    @Published private(set) var isLoading: Bool = false
    
    init() {
       // fetchQuestions()
    }
    
    func fetchQuestions() {
        isLoading = true
        let infoRef = db.collection("Quiz").document("Coding_questions_info")
        
        DispatchQueue.global(qos: .background).async {
            infoRef.getDocument { infoSnap, error in
                guard let infoSnap = infoSnap, error == nil else {
                    print("Error fetching question info: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                let totalQuestions = infoSnap.data()?["totalQuestions"] as? Int ?? 0
                let numQuestions = 10
                let randomIds = self.getRandomIds(n: numQuestions, totalQuestions: totalQuestions)
                
                let group = DispatchGroup()
                var fetchedQuestions: [Question] = []
                
                for id in randomIds {
                    group.enter()
                    self.db.collection("Quiz").document(id).collection("Coding_questions").getDocuments { snapshot, error in
                        defer { group.leave() }
                        guard let snapshot = snapshot, error == nil else {
                            print("Error fetching question with ID \(id): \(String(describing: error))")
                            return
                        }
                        
                        for doc in snapshot.documents {
                            if let question = Question.fromFirestoreData(id: id, data: doc.data()) {
                                fetchedQuestions.append(question)
                            }
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    self.questions = fetchedQuestions
                    self.isLoading = false
                }
            }
        }
    }

    
    private func getRandomIds(n: Int, totalQuestions: Int) -> [String] {
        var randomIds = Set<String>()
        while randomIds.count < n {
            let randomId = Int.random(in: 1...totalQuestions)
            randomIds.insert(String(randomId))
        }
        return Array(randomIds)
    }
}
