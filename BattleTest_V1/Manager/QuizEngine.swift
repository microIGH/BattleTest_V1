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
    
    // LÓGICA EXACTA DE TU JAVASCRIPT processAnswer (CORREGIDA)
    func processAnswer(_ selectedAnswer: String) -> QuizEngineResult {
        let currentQuestion = session.selectedQuestions[session.currentQuestionIndex]
        let correctAnswer = currentQuestion.correctAnswer
        
        // TRADUCCIÓN EXACTA DE TU JS (CORREGIDA):
        if !session.processedQuestions[session.currentQuestionIndex] {
            // Primera vez respondiendo esta pregunta
            session.processedQuestions[session.currentQuestionIndex] = true
            session.selectedAnswers[session.currentQuestionIndex] = selectedAnswer
            
            if selectedAnswer == correctAnswer {
                session.score += 1
            } else {
                session.penaltyCount += 1
            }
        } else {
            // Cambio de respuesta - LÓGICA CORREGIDA
            let previousAnswer = session.selectedAnswers[session.currentQuestionIndex]
            
            if previousAnswer != selectedAnswer {
                // Solo procesar si realmente cambió la respuesta
                
                // Revertir efecto de respuesta anterior
                if previousAnswer == correctAnswer {
                    session.score -= 1  // Quitar punto si la anterior era correcta
                }
                
                // Aplicar efecto de nueva respuesta
                if selectedAnswer == correctAnswer {
                    session.score += 1  // Dar punto si la nueva es correcta
                } else {
                    session.penaltyCount += 1  // Penalizar si la nueva es incorrecta
                }
                
                // Actualizar respuesta guardada
                session.selectedAnswers[session.currentQuestionIndex] = selectedAnswer
            }
        }
        
        // Verificar límite de penalizaciones (como tu JS)
        if session.penaltyCount > 3 {
            return .restartRequired
        }
        
        return .continueQuiz
    }
    
    // LÓGICA DE NAVEGACIÓN HACIA ATRÁS (como tu JS back-btn)
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
    
    // AVANZAR A SIGUIENTE PREGUNTA
    func moveToNextQuestion() -> QuizEngineResult {
        session.currentQuestionIndex += 1
        
        if session.currentQuestionIndex >= session.minQuestionsNumber {
            return .quizCompleted
        }
        
        return .continueQuiz
    }
    
    // OBTENER OPCIONES MEZCLADAS (como tu JS shuffledOptions)
    func getShuffledOptions(for questionIndex: Int) -> [String] {
        return session.selectedQuestions[questionIndex].options.shuffled()
    }
    
    // VERIFICAR SI HAY RESPUESTA SELECCIONADA PREVIAMENTE
    func getPreviousAnswer(for questionIndex: Int) -> String? {
        let answer = session.selectedAnswers[questionIndex]
        return answer.isEmpty ? nil : answer
    }
}
