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
    

    var totalPoints: Int
    var level: Int
    var experiencePoints: Int
    

    var achievements: [Achievement]
    var lastAchievementDate: Date?
    var achievementPointsToday: Int
    

    var currentStreak: Int
    var bestStreak: Int
    var lastActivityDate: Date?
    var lastStreakRewardDate: Date?
    

    var totalStudyTime: TimeInterval
    var completedQuizzes: [String]
    var quizResults: [QuizResult]
    var subjectsExplored: Set<String>
    

    var dailyQuizCount: Int
    var lastQuizDate: Date?
    

    init(name: String, email: String) {
        self.id = UUID().uuidString
        self.name = name
        self.email = email
        self.registrationDate = Date()
        
        self.totalPoints = 0
        self.level = 1
        self.experiencePoints = 0
        

        self.achievements = Achievement.allAchievements.map { achievement in
            var userAchievement = achievement
            userAchievement.status = .unlocked
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
        return ((level - 1) * (level - 1) * 75) + 150
    }
    
    mutating func addAchievement(_ achievement: Achievement) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {

            guard achievements[index].status != .earned else { return }
            
            let today = Calendar.current.startOfDay(for: Date())
            let lastAchievementDay = lastAchievementDate.map { Calendar.current.startOfDay(for: $0) }
            
            if lastAchievementDay != today {
                achievementPointsToday = 0
            }
            
            guard achievementPointsToday + achievement.points <= 50 else { return }
            
            achievements[index].status = .earned
            achievements[index].earnedDate = Date()
            
            totalPoints += achievement.points
            achievementPointsToday += achievement.points
            lastAchievementDate = Date()
            
            updateLevel()
        }
    }
    
    func getEarnedAchievements() -> [Achievement] {
        return achievements.filter { $0.status == .earned }
    }
    
    func getAchievementsByType(_ type: AchievementType) -> [Achievement] {
        return achievements.filter { $0.type == type }
    }
    
    mutating func addQuizResult(_ result: QuizResult) {
        quizResults.append(result)
        
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
        
        if !completedQuizzes.contains(result.quizId) {
            completedQuizzes.append(result.quizId)
        }
        
        subjectsExplored.insert(result.subjectId)
        
        totalStudyTime += result.completionTime
        
        updateStreak()
        
        updateDailyCounters()
        
        updateLevel()
    }
    
    private mutating func updateStreak() {
        let now = Date()
        let calendar = Calendar.current
        
        if let lastActivity = lastActivityDate {
            let daysBetween = calendar.dateComponents([.day], from: lastActivity, to: now).day ?? 0
            
            if daysBetween == 1 {
                currentStreak += 1
                if currentStreak > bestStreak {
                    bestStreak = currentStreak
                }
            } else if daysBetween > 1 {
                currentStreak = 1
            }
        } else {
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
    
    func getProgressBySubject() -> [String: (completed: Int, total: Int, percentage: Float)] {
        var progress: [String: (completed: Int, total: Int, percentage: Float)] = [:]
        
        let subjectQuizCounts = [
            "biologia": 2,
            "fisica": 2,
            "quimica": 2,
            "matematicas": 2
        ]
        
        for (subjectId, totalQuizzes) in subjectQuizCounts {
            let completedInSubject = quizResults.filter { $0.subjectId == subjectId }.count
            let percentage = totalQuizzes > 0 ? Float(completedInSubject) / Float(totalQuizzes) * 100 : 0
            progress[subjectId] = (completed: completedInSubject, total: totalQuizzes, percentage: percentage)
        }
        
        return progress
    }
    
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
            
            weekActivity[6-i] = quizzesInDay 
        }
        
        return weekActivity
    }
}

