//
//  QuizResult.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import Foundation

struct QuizResult: Codable {
    let quizId: String
    let subjectId: String
    let score: Int
    let totalQuestions: Int
    let penaltyCount: Int
    let completionTime: TimeInterval
    let date: Date
    let passed: Bool
    
    var scorePercentage: Float {
        return Float(score) / Float(totalQuestions) * 100
    }
    
    var scoreDisplay: String {
        return "\(score)/\(totalQuestions)"
    }
    
    init(session: QuizSession) {
        self.quizId = session.quiz.id
        self.subjectId = session.subject.id
        self.score = session.score
        self.totalQuestions = session.minQuestionsNumber
        self.penaltyCount = session.penaltyCount
        self.completionTime = Date().timeIntervalSince(session.startTime)
        self.date = Date()
        self.passed = Float(score) / Float(totalQuestions) >= 0.7 // 70% para aprobar
    }
}
