//
//  Quiz.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation

struct Quiz: Codable {
    let id: String
    let title: String
    let subjectId: String
    let minQuestionsNumber: Int
    let language: String
    let questions: [Question]
    var isCompleted: Bool
    var bestScore: Int
    var attempts: Int
    
    init(id: String, title: String, subjectId: String, minQuestionsNumber: Int, language: String = "es", questions: [Question] = []) {
        self.id = id
        self.title = title
        self.subjectId = subjectId
        self.minQuestionsNumber = minQuestionsNumber
        self.language = language  // AGREGAR ESTA LÍNEA
        self.questions = questions
        self.isCompleted = false
        self.bestScore = 0
        self.attempts = 0
    }
}

struct Question: Codable {
    let question: String
    let options: [String]
    let correctAnswer: String
}
