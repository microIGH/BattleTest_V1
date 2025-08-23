//
//  QuizSession.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import Foundation

class QuizSession: ObservableObject {
    let quiz: Quiz
    let subject: Subject
    var selectedQuestions: [Question] = []
    var currentQuestionIndex: Int = 0
    var score: Int = 0
    var penaltyCount: Int = 0
    var selectedAnswers: [String] = []
    var processedQuestions: [Bool] = []
    var startTime: Date
    var endTime: Date?
    
    var minQuestionsNumber: Int {
        return quiz.minQuestionsNumber
    }
    
    var isCompleted: Bool {
        return currentQuestionIndex >= minQuestionsNumber
    }
    
    var progressPercentage: Float {
        return Float(currentQuestionIndex + 1) / Float(minQuestionsNumber)
    }
    
    init(quiz: Quiz, subject: Subject) {
        self.quiz = quiz
        self.subject = subject
        self.startTime = Date()
        setupQuiz()
    }
    
    private func setupQuiz() {
        // Obtener preguntas aleatorias (como getRandomQuestions de tu JS)
        selectedQuestions = getRandomQuestions(from: quiz.questions, count: minQuestionsNumber)
        
        // Inicializar arrays
        selectedAnswers = Array(repeating: "", count: minQuestionsNumber)
        processedQuestions = Array(repeating: false, count: minQuestionsNumber)
    }
    
    private func getRandomQuestions(from questions: [Question], count: Int) -> [Question] {
        let shuffled = questions.shuffled()
        return Array(shuffled.prefix(count))
    }
    
    func reset() {
        currentQuestionIndex = 0
        score = 0
        penaltyCount = 0
        startTime = Date()
        endTime = nil
        setupQuiz()
    }
}
