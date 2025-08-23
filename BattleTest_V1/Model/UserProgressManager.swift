//
//  UserProgressManager.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation

class UserProgressManager {
    static let shared = UserProgressManager()
    
    private init() {}
    
    // MARK: - Original Methods (Mantener compatibilidad)
    
    func getCurrentUser() -> Student? {
        guard let userData = UserDefaults.standard.data(forKey: "currentUser"),
              let student = try? JSONDecoder().decode(Student.self, from: userData) else {
            return nil
        }
        return student
    }
    
    func saveUser(_ student: Student) {
        if let encoded = try? JSONEncoder().encode(student) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
            
            var settings = AppSettings.shared
            settings.isFirstTime = false
            settings.save()
        }
    }
    
    func isFirstTime() -> Bool {
        return AppSettings.shared.isFirstTime
    }
    
    // MARK: - New Achievement Integration Methods
    
    /// Procesa un resultado de quiz completo con achievements automáticos
    /// ORIGEN: QuizResult recién completado desde QuizResultsViewController
    /// PROCESO: Agregar resultado al Student + evaluar achievements + persistir
    /// DESTINO: Student actualizado con nuevos puntos, achievements y estadísticas
    func processQuizCompletion(_ result: QuizResult) -> [Achievement] {
        guard var student = getCurrentUser() else {
            print("❌ Error: No se pudo obtener el usuario actual")
            return []
        }
        
        // Agregar resultado al historial del student (esto calcula puntos base automáticamente)
        student.addQuizResult(result)
        
        // Evaluar y otorgar achievements correspondientes
        let newAchievements = AchievementManager.shared.evaluateAchievements(for: result, student: &student)
        
        // Persistir cambios
        saveUser(student)
        
        // Log para debugging
        if !newAchievements.isEmpty {
            print("🏆 Quiz completado: +\(result.score * 2) puntos base")
            print("🏆 Achievements obtenidos: \(newAchievements.map { "\($0.title) (+\($0.points)pts)" }.joined(separator: ", "))")
            print("🏆 Total puntos: \(student.totalPoints), Nivel: \(student.level)")
        }
        
        return newAchievements
    }
    
    /// Actualiza solo los achievements sin agregar un nuevo resultado de quiz
    /// Útil para recalcular achievements después de cambios en criterios
    func recalculateAchievements() {
        guard var student = getCurrentUser() else { return }
        
        // Reset achievements to unlocked state
        for i in 0..<student.achievements.count {
            if student.achievements[i].status == .earned {
                student.achievements[i].status = .unlocked
                student.achievements[i].earnedDate = nil
            }
        }
        
        // Reset achievement points
        let originalPoints = student.totalPoints
        student.totalPoints = 0
        student.achievementPointsToday = 0
        
        // Recalculate base points from quiz results
        for result in student.quizResults {
            student.totalPoints += result.score * 2  // 2 puntos por respuesta correcta
            if result.passed {
                student.totalPoints += 10  // Bonus por aprobar
                if result.scorePercentage >= 90 {
                    student.totalPoints += 5  // Bonus por excelencia
                }
                if result.scorePercentage == 100 {
                    student.totalPoints += 5  // Bonus adicional por perfección
                }
            }
        }
        
        // Re-evaluate all achievements
        for result in student.quizResults {
            let _ = AchievementManager.shared.evaluateAchievements(for: result, student: &student)
        }
        
        saveUser(student)
        print("🔄 Achievements recalculados. Puntos: \(originalPoints) → \(student.totalPoints)")
    }
    
    // MARK: - Dashboard Statistics Methods
    
    /// Obtiene estadísticas para el Dashboard gamificado
    /// ORIGEN: Dashboard necesita datos actualizados para mostrar
    /// PROCESO: Calcular estadísticas en tiempo real del Student actual
    /// DESTINO: Estructura de datos lista para mostrar en UI
    func getDashboardStats() -> DashboardStats? {
        guard let student = getCurrentUser() else { return nil }
        
        let achievementProgress = AchievementManager.shared.getAchievementProgress(for: student)
        let recentAchievements = AchievementManager.shared.getRecentAchievements(for: student, limit: 3)
        
        return DashboardStats(
            totalPoints: student.totalPoints,
            level: student.level,
            progressToNextLevel: student.progressToNextLevel,
            experienceNeeded: student.experienceNeededForNextLevel,
            currentStreak: student.currentStreak,
            bestStreak: student.bestStreak,
            averageScore: student.averageScore,
            totalQuizzes: student.totalQuizzesCompleted,
            subjectsExplored: student.subjectsExploredCount,
            achievementsEarned: achievementProgress.earned,
            achievementsTotal: achievementProgress.total,
            achievementPercentage: achievementProgress.percentage,
            recentAchievements: recentAchievements,
            weeklyActivity: student.getWeeklyActivity(),
            totalStudyTime: student.totalStudyTime
        )
    }
    
    /// Obtiene estadísticas para el ProfileViewController
    /// ORIGEN: Profile necesita datos detallados del estudiante
    /// PROCESO: Calcular progreso por asignatura y estadísticas detalladas
    /// DESTINO: Estructura de datos para ProfileViewController
    func getProfileStats() -> ProfileStats? {
        guard let student = getCurrentUser() else { return nil }
        
        let progressBySubject = student.getProgressBySubject()
        let earnedAchievements = student.getEarnedAchievements()
        let achievementsByType = Dictionary(grouping: earnedAchievements) { $0.type }
        
        return ProfileStats(
            studentName: student.name,
            studentEmail: student.email,
            registrationDate: student.registrationDate,
            totalPoints: student.totalPoints,
            level: student.level,
            currentStreak: student.currentStreak,
            bestStreak: student.bestStreak,
            totalStudyTime: student.totalStudyTime,
            averageScore: student.averageScore,
            totalQuizzes: student.totalQuizzesCompleted,
            progressBySubject: progressBySubject,
            achievementsByType: achievementsByType,
            recentResults: student.recentResults
        )
    }
    
    // MARK: - Achievement Management
    
    /// Obtiene achievements por categoría para mostrar en UI
    func getAchievementsByCategory() -> [AchievementType: [Achievement]] {
        guard let student = getCurrentUser() else { return [:] }
        
        return Dictionary(grouping: student.achievements) { $0.type }
    }
    
    /// Verifica si hay nuevos achievements disponibles para mostrar notificación
    func hasNewAchievements() -> Bool {
        guard let student = getCurrentUser() else { return false }
        
        // Verificar si hay achievements obtenidos en las últimas 24 horas
        let yesterday = Date().addingTimeInterval(-86400)
        return student.achievements.contains { achievement in
            if let earnedDate = achievement.earnedDate {
                return earnedDate > yesterday
            }
            return false
        }
    }
    
    // MARK: - Utility Methods
    
    /// Reinicia el progreso del usuario (útil para testing)
    func resetUserProgress() {
        guard var student = getCurrentUser() else { return }
        
        // Reset core progress
        student.totalPoints = 0
        student.level = 1
        student.experiencePoints = 0
        
        // Reset achievements
        for i in 0..<student.achievements.count {
            student.achievements[i].status = .unlocked
            student.achievements[i].earnedDate = nil
        }
        student.achievementPointsToday = 0
        student.lastAchievementDate = nil
        
        // Reset streak
        student.currentStreak = 0
        student.bestStreak = 0
        student.lastActivityDate = nil
        student.lastStreakRewardDate = nil
        
        // Reset statistics
        student.totalStudyTime = 0
        student.completedQuizzes.removeAll()
        student.quizResults.removeAll()
        student.subjectsExplored.removeAll()
        
        // Reset anti-exploit counters
        student.dailyQuizCount = 0
        student.lastQuizDate = nil
        
        saveUser(student)
        print("🔄 Progreso del usuario reiniciado completamente")
    }
    
    /// Actualiza streak manualmente (útil para testing o correcciones)
    func updateStreak(to newStreak: Int) {
        guard var student = getCurrentUser() else { return }
        
        student.currentStreak = newStreak
        if newStreak > student.bestStreak {
            student.bestStreak = newStreak
        }
        student.lastActivityDate = Date()
        
        saveUser(student)
        print("🔥 Streak actualizado a \(newStreak) días")
    }
}

// MARK: - Data Structures for UI

struct DashboardStats {
    let totalPoints: Int
    let level: Int
    let progressToNextLevel: Float
    let experienceNeeded: Int
    let currentStreak: Int
    let bestStreak: Int
    let averageScore: Float
    let totalQuizzes: Int
    let subjectsExplored: Int
    let achievementsEarned: Int
    let achievementsTotal: Int
    let achievementPercentage: Float
    let recentAchievements: [Achievement]
    let weeklyActivity: [Int]
    let totalStudyTime: TimeInterval
}

struct ProfileStats {
    let studentName: String
    let studentEmail: String
    let registrationDate: Date
    let totalPoints: Int
    let level: Int
    let currentStreak: Int
    let bestStreak: Int
    let totalStudyTime: TimeInterval
    let averageScore: Float
    let totalQuizzes: Int
    let progressBySubject: [String: (completed: Int, total: Int, percentage: Float)]
    let achievementsByType: [AchievementType: [Achievement]]
    let recentResults: [QuizResult]
}		
