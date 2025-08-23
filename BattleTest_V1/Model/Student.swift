//
//  Student.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation

struct Student: Codable {
    let id: String
    let name: String
    let email: String
    let registrationDate: Date
    
    // MARK: - Core Progress Properties
    var totalPoints: Int
    var level: Int
    var experiencePoints: Int  // Puntos para el siguiente nivel
    
    // MARK: - Achievement System
    var achievements: [Achievement]
    var lastAchievementDate: Date?
    var achievementPointsToday: Int  // Anti-exploit: máximo diario
    
    // MARK: - Streak System
    var currentStreak: Int
    var bestStreak: Int
    var lastActivityDate: Date?
    var lastStreakRewardDate: Date?  // Anti-exploit: una vez por día
    
    // MARK: - Study Statistics
    var totalStudyTime: TimeInterval
    var completedQuizzes: [String]  // IDs de quizzes completados
    var quizResults: [QuizResult]   // Historial completo de resultados
    var subjectsExplored: Set<String>  // Asignaturas donde ha hecho quizzes
    
    // MARK: - Anti-Exploit Tracking
    var dailyQuizCount: Int
    var lastQuizDate: Date?
    
    // MARK: - Initialization
    init(name: String, email: String) {
        self.id = UUID().uuidString
        self.name = name
        self.email = email
        self.registrationDate = Date()
        
        // Core progress
        self.totalPoints = 0
        self.level = 1
        self.experiencePoints = 0
        
        // Achievement system
        self.achievements = Achievement.allAchievements.map { achievement in
            var userAchievement = achievement
            userAchievement.status = .unlocked  // Todos empiezan desbloqueados
            return userAchievement
        }
        self.lastAchievementDate = nil
        self.achievementPointsToday = 0
        
        // Streak system
        self.currentStreak = 0
        self.bestStreak = 0
        self.lastActivityDate = nil
        self.lastStreakRewardDate = nil
        
        // Study statistics
        self.totalStudyTime = 0
        self.completedQuizzes = []
        self.quizResults = []
        self.subjectsExplored = Set<String>()
        
        // Anti-exploit
        self.dailyQuizCount = 0
        self.lastQuizDate = nil
    }
    
    // MARK: - Experience and Level Calculation
    var experienceForCurrentLevel: Int {
        return calculateExperienceForLevel(level)
    }
    
    var experienceForNextLevel: Int {
        return calculateExperienceForLevel(level + 1)
    }
    
    var progressToNextLevel: Float {
        let currentLevelExp = experienceForCurrentLevel
        let nextLevelExp = experienceForNextLevel
        let progressExp = totalPoints - currentLevelExp
        let neededExp = nextLevelExp - currentLevelExp
        
        return Float(progressExp) / Float(neededExp)
    }
    
    var experienceNeededForNextLevel: Int {
        return experienceForNextLevel - totalPoints
    }
    
    private func calculateExperienceForLevel(_ level: Int) -> Int {
        if level <= 1 { return 0 }
        // Fórmula más gradual: nextLevel = (currentLevel * currentLevel * 75) + 150
        return ((level - 1) * (level - 1) * 75) + 150
    }
    
    // MARK: - Achievement Management
    mutating func addAchievement(_ achievement: Achievement) {
        // Buscar el achievement en el array del usuario
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            // Verificar que no esté ya obtenido
            guard achievements[index].status != .earned else { return }
            
            // Verificar límite diario de achievement points
            let today = Calendar.current.startOfDay(for: Date())
            let lastAchievementDay = lastAchievementDate.map { Calendar.current.startOfDay(for: $0) }
            
            // Resetear contador si es un nuevo día
            if lastAchievementDay != today {
                achievementPointsToday = 0
            }
            
            // Verificar límite diario (máximo 50 puntos por día en achievements)
            guard achievementPointsToday + achievement.points <= 50 else { return }
            
            // Otorgar el achievement
            achievements[index].status = .earned
            achievements[index].earnedDate = Date()
            
            // Agregar puntos
            totalPoints += achievement.points
            achievementPointsToday += achievement.points
            lastAchievementDate = Date()
            
            // Recalcular nivel
            updateLevel()
        }
    }
    
    func getEarnedAchievements() -> [Achievement] {
        return achievements.filter { $0.status == .earned }
    }
    
    func getAchievementsByType(_ type: AchievementType) -> [Achievement] {
        return achievements.filter { $0.type == type }
    }
    
    // MARK: - Quiz Result Management
    mutating func addQuizResult(_ result: QuizResult) {
        // Agregar resultado al historial
        quizResults.append(result)
        
        // Actualizar estadísticas básicas
        totalPoints += result.score * 2  // 2 puntos por respuesta correcta
        if result.passed {
            totalPoints += 10  // Bonus por aprobar
            if result.scorePercentage >= 90 {
                totalPoints += 5  // Bonus por excelencia
            }
            if result.scorePercentage == 100 {
                totalPoints += 5  // Bonus adicional por perfección
            }
        }
        
        // Agregar quiz a completados si no existe
        if !completedQuizzes.contains(result.quizId) {
            completedQuizzes.append(result.quizId)
        }
        
        // Agregar asignatura explorada
        subjectsExplored.insert(result.subjectId)
        
        // Actualizar tiempo de estudio
        totalStudyTime += result.completionTime
        
        // Actualizar streak
        updateStreak()
        
        // Actualizar contadores anti-exploit
        updateDailyCounters()
        
        // Recalcular nivel
        updateLevel()
    }
    
    // MARK: - Streak Management
    private mutating func updateStreak() {
        let now = Date()
        let calendar = Calendar.current
        
        if let lastActivity = lastActivityDate {
            let daysBetween = calendar.dateComponents([.day], from: lastActivity, to: now).day ?? 0
            
            if daysBetween == 1 {
                // Día consecutivo: incrementar streak
                currentStreak += 1
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
            } else if daysBetween > 1 {
                // Se rompió la racha
                currentStreak = 1
            }
            // Si daysBetween == 0, es el mismo día, no cambia el streak
        } else {
            // Primera actividad
            currentStreak = 1
            bestStreak = 1
        }
        
        lastActivityDate = now
    }
    
    private mutating func updateDailyCounters() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastQuizDay = lastQuizDate.map { Calendar.current.startOfDay(for: $0) }
        
        if lastQuizDay != today {
            dailyQuizCount = 1
        } else {
            dailyQuizCount += 1
        }
        
        lastQuizDate = Date()
    }
    
    private mutating func updateLevel() {
        let newLevel = calculateLevelFromPoints(totalPoints)
        if newLevel > level {
            level = newLevel
        }
    }
    
    private func calculateLevelFromPoints(_ points: Int) -> Int {
        var level = 1
        while calculateExperienceForLevel(level + 1) <= points {
            level += 1
        }
        return level
    }
    
    // MARK: - Statistics for Dashboard
    var averageScore: Float {
        guard !quizResults.isEmpty else { return 0.0 }
        let totalPercentage = quizResults.reduce(0) { $0 + $1.scorePercentage }
        return totalPercentage / Float(quizResults.count)
    }
    
    var totalQuizzesCompleted: Int {
        return completedQuizzes.count
    }
    
    var subjectsExploredCount: Int {
        return subjectsExplored.count
    }
    
    var recentResults: [QuizResult] {
        return Array(quizResults.suffix(5))  // Últimos 5 resultados
    }
    
    // Progreso por asignatura para ProfileViewController
    // Progreso por asignatura para ProfileViewController
    func getProgressBySubject() -> [String: (completed: Int, total: Int, percentage: Float)] {
        var progress: [String: (completed: Int, total: Int, percentage: Float)] = [:]
        
        // ACTUALIZADO: Nuevas asignaturas con sus totales de quizzes reales
        let subjectQuizCounts = [
            "biologia": 2,      // 2 quizzes: Células y Tejidos + Genética Básica
            "fisica": 2,        // 2 quizzes: Mecánica Básica + Electricidad
            "quimica": 2,       // 2 quizzes: Tabla Periódica + Enlaces Químicos
            "matematicas": 2    // 2 quizzes: Álgebra Básica + Geometría
        ]
        
        for (subjectId, totalQuizzes) in subjectQuizCounts {
            let completedInSubject = quizResults.filter { $0.subjectId == subjectId }.count
            let percentage = totalQuizzes > 0 ? Float(completedInSubject) / Float(totalQuizzes) * 100 : 0
            progress[subjectId] = (completed: completedInSubject, total: totalQuizzes, percentage: percentage)
        }
        
        return progress
    }
    
    // Weekly activity for charts
    func getWeeklyActivity() -> [Int] {
        let calendar = Calendar.current
        let now = Date()
        var weekActivity: [Int] = Array(repeating: 0, count: 7)
        
        for i in 0..<7 {
            let day = calendar.date(byAdding: .day, value: -i, to: now)!
            let dayStart = calendar.startOfDay(for: day)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            let quizzesInDay = quizResults.filter { result in
                result.date >= dayStart && result.date < dayEnd
            }.count
            
            weekActivity[6-i] = quizzesInDay  // Invertir para que [0] sea hace 7 días
        }
        
        return weekActivity
    }
}

