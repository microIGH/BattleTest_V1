//
//  AchievementManager.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import Foundation

class AchievementManager {
    static let shared = AchievementManager()
    
    private init() {}
    

    func evaluateAchievements(for result: QuizResult, student: inout Student) -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        
        guard canEarnMoreAchievements(student: student) else {
            return newAchievements
        }
        
        // Evaluar cada tipo de achievement
        if let velocityAchievement = evaluateVelocityAchievements(result: result, student: student) {
            student.addAchievement(velocityAchievement)
            newAchievements.append(velocityAchievement)
        }
        
        if let precisionAchievement = evaluatePrecisionAchievements(result: result, student: student) {
            student.addAchievement(precisionAchievement)
            newAchievements.append(precisionAchievement)
        }
        
        if let consistencyAchievement = evaluateConsistencyAchievements(student: student) {
            student.addAchievement(consistencyAchievement)
            newAchievements.append(consistencyAchievement)
        }
        
        if let explorerAchievement = evaluateExplorerAchievements(result: result, student: student) {
            student.addAchievement(explorerAchievement)
            newAchievements.append(explorerAchievement)
        }
        
        if let perfectionistAchievement = evaluatePerfectionistAchievements(result: result, student: student) {
            student.addAchievement(perfectionistAchievement)
            newAchievements.append(perfectionistAchievement)
        }
        
        return newAchievements
    }
    
    
    
    private func canEarnMoreAchievements(student: Student) -> Bool {
        // Verificar límite diario de achievement points (máximo 50 por día)
        let today = Calendar.current.startOfDay(for: Date())
        let lastAchievementDay = student.lastAchievementDate.map { Calendar.current.startOfDay(for: $0) }
        
        if lastAchievementDay == today && student.achievementPointsToday >= 50 {
            return false
        }
        
        if student.dailyQuizCount > 20 {
            return false
        }
        
        return true
    }
    
    private func hasEarnedAchievement(achievementId: String, student: Student) -> Bool {
        return student.achievements.first { $0.id == achievementId }?.status == .earned
    }
    
    private func canEarnVelocityAchievement(for quizId: String, student: Student) -> Bool {
        
        let velocityAchievementsForQuiz = student.quizResults.filter { result in
            result.quizId == quizId &&
            hasVelocityAchievementForResult(result, in: student.getEarnedAchievements())
        }
        
        return velocityAchievementsForQuiz.isEmpty
    }
    
    private func hasVelocityAchievementForResult(_ result: QuizResult, in achievements: [Achievement]) -> Bool {
        let velocityAchievements = achievements.filter { $0.type == .velocity }
        
        for achievement in velocityAchievements {
            if case .velocity(let maxSeconds, _) = achievement.criteria {
                let avgTime = result.completionTime / Double(result.totalQuestions)
                if avgTime <= maxSeconds {
                    return true
                }
            }
        }
        return false
    }
    
    
    private func evaluateVelocityAchievements(result: QuizResult, student: Student) -> Achievement? {
        
        guard result.scorePercentage >= 70.0 else { return nil }  // Mínimo 70% aciertos
        guard result.totalQuestions >= 5 else { return nil }      // Mínimo 5 preguntas
        guard canEarnVelocityAchievement(for: result.quizId, student: student) else { return nil }
        
        let avgTimePerQuestion = result.completionTime / Double(result.totalQuestions)
        guard avgTimePerQuestion >= 5.0 else { return nil }       // Anti-bot: mínimo 5s por pregunta
        
        //mejor achievement de velocidad que califique
        let velocityAchievements = Achievement.allAchievements.filter { $0.type == .velocity }
            .sorted { $0.points > $1.points }  // Ordenar por puntos (mayor a menor)
        
        for achievement in velocityAchievements {
            // Verificar si ya lo tiene
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .velocity(let maxSeconds, let minAccuracy) = achievement.criteria {
                if avgTimePerQuestion <= maxSeconds && Double(result.scorePercentage) >= minAccuracy {
                    
                    return achievement
                }
            }
        }
        
        return nil
    }
    
    
    private func evaluatePrecisionAchievements(result: QuizResult, student: Student) -> Achievement? {
        guard result.scorePercentage == 100.0 else { return nil }
        
        let precisionAchievements = Achievement.allAchievements.filter { $0.type == .precision }
        
        for achievement in precisionAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            switch achievement.criteria {
            case .precision(let requiredAccuracy, let minQuestions):
                if Double(result.scorePercentage) >= requiredAccuracy && result.totalQuestions >= minQuestions {
                    // Verificar cooldown de 1 hora para mismo quiz
                    if canEarnPrecisionAchievement(for: result.quizId, student: student) {
                        return achievement
                    }
                }
                
            case .precisionStreak(let requiredStreak, let requiredAccuracy):
                if checkPrecisionStreak(requiredStreak: requiredStreak,
                                       requiredAccuracy: requiredAccuracy,
                                       student: student) {
                    return achievement
                }
                
            case .precisionAllSubjects(let requiredAccuracy):
                if checkPrecisionAllSubjects(requiredAccuracy: requiredAccuracy, student: student) {
                    return achievement
                }
                
            default:
                continue
            }
        }
        
        return nil
    }
    
    private func canEarnPrecisionAchievement(for quizId: String, student: Student) -> Bool {
        let oneHourAgo = Date().addingTimeInterval(-3600)
        let recentSameQuiz = student.quizResults.filter {
            $0.quizId == quizId && $0.date > oneHourAgo
        }
        return recentSameQuiz.count <= 1  // Solo el actual
    }
    
    private func checkPrecisionStreak(requiredStreak: Int, requiredAccuracy: Double, student: Student) -> Bool {
        let recentResults = Array(student.quizResults.suffix(requiredStreak))
        guard recentResults.count >= requiredStreak else { return false }
        
        return recentResults.allSatisfy { Double($0.scorePercentage) >= requiredAccuracy }
    }
    
    private func checkPrecisionAllSubjects(requiredAccuracy: Double, student: Student) -> Bool {
        let subjectIds = ["biologia", "matematicas", "computacion", "geografia"]
        
        return subjectIds.allSatisfy { subjectId in
            student.quizResults.contains { result in
                result.subjectId == subjectId && Double(result.scorePercentage) >= requiredAccuracy
            }
        }
    }
    
    
    private func evaluateConsistencyAchievements(student: Student) -> Achievement? {
        let consistencyAchievements = Achievement.allAchievements.filter { $0.type == .consistency }
        
        for achievement in consistencyAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .consistency(let requiredDays) = achievement.criteria {
                if student.currentStreak >= requiredDays {
                    if canEarnStreakReward(student: student) {
                        return achievement
                    }
                }
            }
        }
        
        return nil
    }
    
    private func canEarnStreakReward(student: Student) -> Bool {
        guard let lastReward = student.lastStreakRewardDate else { return true }
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastRewardDay = Calendar.current.startOfDay(for: lastReward)
        
        return today > lastRewardDay
    }
    
    
    private func evaluateExplorerAchievements(result: QuizResult, student: Student) -> Achievement? {
        let explorerAchievements = Achievement.allAchievements.filter { $0.type == .explorer }
        
        for achievement in explorerAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .explorer(let requiredSubjects) = achievement.criteria {
                if student.subjectsExploredCount >= requiredSubjects {
                    return achievement
                }
            }
        }
        
        return nil
    }
    
    private func evaluatePerfectionistAchievements(result: QuizResult, student: Student) -> Achievement? {
        guard result.scorePercentage == 100.0 else { return nil }
        
        let perfectionistAchievements = Achievement.allAchievements.filter { $0.type == .perfectionist }
        
        for achievement in perfectionistAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            switch achievement.criteria {
            case .perfectionist(let requiredPerfectQuizzes, let allowRetries):
                if checkPerfectionistCriteria(requiredPerfectQuizzes: requiredPerfectQuizzes,
                                            allowRetries: allowRetries,
                                            student: student) {
                    return achievement
                }
                
            case .perfectAbsolute(let requiredAccuracy, let maxSecondsPerQuestion):
                if Double(result.scorePercentage) >= requiredAccuracy {
                    let avgTime = result.completionTime / Double(result.totalQuestions)
                    if avgTime <= maxSecondsPerQuestion {
                        return achievement
                    }
                }
                
            default:
                continue
            }
        }
        
        return nil
    }
    
    private func checkPerfectionistCriteria(requiredPerfectQuizzes: Int, allowRetries: Bool, student: Student) -> Bool {
        if allowRetries {
            let perfectResults = student.quizResults.filter { $0.scorePercentage == 100.0 }
            return perfectResults.count >= requiredPerfectQuizzes
        } else {
            let perfectQuizIds = Set(student.quizResults.filter { $0.scorePercentage == 100.0 }.map { $0.quizId })
            return perfectQuizIds.count >= requiredPerfectQuizzes
        }
    }
    
    func getAchievementProgress(for student: Student) -> (earned: Int, total: Int, percentage: Float) {
        let earned = student.getEarnedAchievements().count
        let total = Achievement.allAchievements.count
        let percentage = Float(earned) / Float(total) * 100
        
        return (earned: earned, total: total, percentage: percentage)
    }
    
    func getRecentAchievements(for student: Student, limit: Int = 3) -> [Achievement] {
        return student.getEarnedAchievements()
            .sorted { ($0.earnedDate ?? Date.distantPast) > ($1.earnedDate ?? Date.distantPast) }
            .prefix(limit)
            .map { $0 }
    }
}
