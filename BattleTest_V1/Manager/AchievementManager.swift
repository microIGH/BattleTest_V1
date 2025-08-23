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
    
    // MARK: - Main Achievement Evaluation
    
    /// Evalúa un resultado de quiz y otorga achievements correspondientes
    /// ORIGEN: QuizResult recién completado + Student actual
    /// PROCESO: Evaluar cada tipo de achievement con validaciones anti-exploit
    /// DESTINO: Student actualizado con nuevos achievements otorgados
    func evaluateAchievements(for result: QuizResult, student: inout Student) -> [Achievement] {
        var newAchievements: [Achievement] = []
        
        // Verificar límites anti-exploit
        guard canEarnMoreAchievements(student: student) else {
            print("⚠️ Límite diario de achievements alcanzado")
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
        
        // Log para debugging
        if !newAchievements.isEmpty {
            print("🏆 Nuevos achievements otorgados: \(newAchievements.map { $0.title })")
        }
        
        return newAchievements
    }
    
    // MARK: - Anti-Exploit Validations
    
    private func canEarnMoreAchievements(student: Student) -> Bool {
        // Verificar límite diario de achievement points (máximo 50 por día)
        let today = Calendar.current.startOfDay(for: Date())
        let lastAchievementDay = student.lastAchievementDate.map { Calendar.current.startOfDay(for: $0) }
        
        if lastAchievementDay == today && student.achievementPointsToday >= 50 {
            return false
        }
        
        // Verificar que no ha hecho demasiados quizzes hoy (anti-farming)
        if student.dailyQuizCount > 20 {
            return false
        }
        
        return true
    }
    
    private func hasEarnedAchievement(achievementId: String, student: Student) -> Bool {
        return student.achievements.first { $0.id == achievementId }?.status == .earned
    }
    
    private func canEarnVelocityAchievement(for quizId: String, student: Student) -> Bool {
        // Solo puede ganar un achievement de velocidad por quiz específico
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
    
    // MARK: - Velocity Achievement Evaluation
    
    private func evaluateVelocityAchievements(result: QuizResult, student: Student) -> Achievement? {
        // Validaciones básicas anti-exploit
        guard result.scorePercentage >= 70.0 else { return nil }  // Mínimo 70% aciertos
        guard result.totalQuestions >= 5 else { return nil }      // Mínimo 5 preguntas
        guard canEarnVelocityAchievement(for: result.quizId, student: student) else { return nil }
        
        let avgTimePerQuestion = result.completionTime / Double(result.totalQuestions)
        guard avgTimePerQuestion >= 5.0 else { return nil }       // Anti-bot: mínimo 5s por pregunta
        
        // Buscar el mejor achievement de velocidad que califique
        let velocityAchievements = Achievement.allAchievements.filter { $0.type == .velocity }
            .sorted { $0.points > $1.points }  // Ordenar por puntos (mayor a menor)
        
        for achievement in velocityAchievements {
            // Verificar si ya lo tiene
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .velocity(let maxSeconds, let minAccuracy) = achievement.criteria {
                if avgTimePerQuestion <= maxSeconds && Double(result.scorePercentage) >= minAccuracy {
                    print("✅ Velocity Achievement: \(achievement.title) - \(avgTimePerQuestion)s avg")
                    return achievement
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Precision Achievement Evaluation
    
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
                        print("✅ Precision Achievement: \(achievement.title)")
                        return achievement
                    }
                }
                
            case .precisionStreak(let requiredStreak, let requiredAccuracy):
                if checkPrecisionStreak(requiredStreak: requiredStreak,
                                       requiredAccuracy: requiredAccuracy,
                                       student: student) {
                    print("✅ Precision Streak Achievement: \(achievement.title)")
                    return achievement
                }
                
            case .precisionAllSubjects(let requiredAccuracy):
                if checkPrecisionAllSubjects(requiredAccuracy: requiredAccuracy, student: student) {
                    print("✅ Precision All Subjects Achievement: \(achievement.title)")
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
    
    // MARK: - Consistency Achievement Evaluation
    
    private func evaluateConsistencyAchievements(student: Student) -> Achievement? {
        let consistencyAchievements = Achievement.allAchievements.filter { $0.type == .consistency }
        
        for achievement in consistencyAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .consistency(let requiredDays) = achievement.criteria {
                if student.currentStreak >= requiredDays {
                    // Verificar que no haya recibido reward de streak hoy
                    if canEarnStreakReward(student: student) {
                        print("✅ Consistency Achievement: \(achievement.title) - \(student.currentStreak) días")
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
    
    // MARK: - Explorer Achievement Evaluation
    
    private func evaluateExplorerAchievements(result: QuizResult, student: Student) -> Achievement? {
        let explorerAchievements = Achievement.allAchievements.filter { $0.type == .explorer }
        
        for achievement in explorerAchievements {
            guard !hasEarnedAchievement(achievementId: achievement.id, student: student) else { continue }
            
            if case .explorer(let requiredSubjects) = achievement.criteria {
                if student.subjectsExploredCount >= requiredSubjects {
                    print("✅ Explorer Achievement: \(achievement.title) - \(student.subjectsExploredCount) asignaturas")
                    return achievement
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Perfectionist Achievement Evaluation
    
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
                    print("✅ Perfectionist Achievement: \(achievement.title)")
                    return achievement
                }
                
            case .perfectAbsolute(let requiredAccuracy, let maxSecondsPerQuestion):
                if Double(result.scorePercentage) >= requiredAccuracy {
                    let avgTime = result.completionTime / Double(result.totalQuestions)
                    if avgTime <= maxSecondsPerQuestion {
                        print("✅ Perfect Absolute Achievement: \(achievement.title)")
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
            // Contar cualquier quiz donde haya logrado 100%
            let perfectResults = student.quizResults.filter { $0.scorePercentage == 100.0 }
            return perfectResults.count >= requiredPerfectQuizzes
        } else {
            // Contar solo quizzes únicos donde logró 100% en el primer intento
            let perfectQuizIds = Set(student.quizResults.filter { $0.scorePercentage == 100.0 }.map { $0.quizId })
            return perfectQuizIds.count >= requiredPerfectQuizzes
        }
    }
    
    // MARK: - Achievement Statistics
    
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
