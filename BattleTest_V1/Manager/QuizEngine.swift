//
//  QuizEngine.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import Foundation

enum QuizEngineResult {
    case continueQuiz
    case restartRequired
    case quizCompleted
}

class QuizEngine {
    private var session: QuizSession
    
    init(session: QuizSession) {
        self.session = session
    }
    
    func processAnswer(_ selectedAnswer: String) -> QuizEngineResult {
        let currentQuestion = session.selectedQuestions[session.currentQuestionIndex]
        let correctAnswer = currentQuestion.correctAnswer
        
        if !session.processedQuestions[session.currentQuestionIndex] {
            
            session.processedQuestions[session.currentQuestionIndex] = true
            session.selectedAnswers[session.currentQuestionIndex] = selectedAnswer
            
            if selectedAnswer == correctAnswer {
                session.score += 1
            } else {
                session.penaltyCount += 1
            }
        } else {
           
            let previousAnswer = session.selectedAnswers[session.currentQuestionIndex]
            
            if previousAnswer != selectedAnswer {
                
                if previousAnswer == correctAnswer {
                    session.score -= 1  // Quitar punto si la anterior era correcta
                }
                
                if selectedAnswer == correctAnswer {
                    session.score += 1  // Dar punto si la nueva es correcta
                } else {
                    session.penaltyCount += 1  // Penalizar si la nueva es incorrecta
                }
                
                session.selectedAnswers[session.currentQuestionIndex] = selectedAnswer
            }
        }
        
        if session.penaltyCount > 3 {
            return .restartRequired
        }
        
        return .continueQuiz
    }
    
    func processBackNavigation() {
        if session.currentQuestionIndex > 0 {
            let previouslySelectedAnswer = session.selectedAnswers[session.currentQuestionIndex]
            
            if session.processedQuestions[session.currentQuestionIndex] {
                session.processedQuestions[session.currentQuestionIndex] = false
                
                if previouslySelectedAnswer == session.selectedQuestions[session.currentQuestionIndex].correctAnswer {
                    session.score -= 1
                }
            }
            
            session.currentQuestionIndex -= 1
        }
    }
    
    func moveToNextQuestion() -> QuizEngineResult {
        session.currentQuestionIndex += 1
        
        if session.currentQuestionIndex >= session.minQuestionsNumber {
            return .quizCompleted
        }
        
        return .continueQuiz
    }
    
    func getShuffledOptions(for questionIndex: Int) -> [String] {
        return session.selectedQuestions[questionIndex].options.shuffled()
    }
    
    func getPreviousAnswer(for questionIndex: Int) -> String? {
        let answer = session.selectedAnswers[questionIndex]
        return answer.isEmpty ? nil : answer
    }
}
