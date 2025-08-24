//
//  Achievement.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
// Verificando

import Foundation

enum AchievementType: String, CaseIterable, Codable {
    case velocity = "velocity"
    case precision = "precision"
    case consistency = "consistency"
    case explorer = "explorer"
    case perfectionist = "perfectionist"
    
    var category: String {
        switch self {
        case .velocity: return "Velocidad"
        case .precision: return "Precisión"
        case .consistency: return "Consistencia"
        case .explorer: return "Explorador"
        case .perfectionist: return "Perfeccionista"
        }
    }
}


enum AchievementStatus: String, Codable {
    case locked = "locked"       // No disponible aún
    case unlocked = "unlocked"   // Disponible para obtener
    case earned = "earned"       // Ya conseguido
}

enum AchievementDifficulty: String, Codable {
    case bronze = "bronze"
    case silver = "silver"
    case gold = "gold"
    
    var pointsRange: String {
        switch self {
        case .bronze: return "5-10 pts"
        case .silver: return "15-20 pts"
        case .gold: return "25-40 pts"
        }
    }
}


struct Achievement: Codable, Identifiable, Equatable {
    let id: String
    let type: AchievementType
    let difficulty: AchievementDifficulty
    let title: String
    let description: String
    let iconName: String
    let points: Int
    let criteria: AchievementCriteria
    var status: AchievementStatus
    var earnedDate: Date?
    

    var displayTitle: String {
        return title
    }
    
    var displayDescription: String {
        return description
    }
    
    var displayPoints: String {
        return "+\(points) pts"
    }
    
    var isEarned: Bool {
        return status == .earned
    }
    
    var isAvailable: Bool {
        return status == .unlocked || status == .earned
    }
    
    var badgeColor: String {
        if status == .locked {
            return "systemGray3"
        }
        
        switch difficulty {
        case .bronze: return "systemOrange"
        case .silver: return "systemBlue"
        case .gold: return "systemYellow"
        }
    }
    

    static let allAchievements: [Achievement] = [
        Achievement(
            id: "velocity_relampago",
            type: .velocity,
            difficulty: .bronze,
            title: "Relámpago",
            description: "Completa un quiz en menos de 20 segundos por pregunta",
            iconName: "bolt.fill",
            points: 5,
            criteria: AchievementCriteria.velocity(maxSecondsPerQuestion: 20.0, minAccuracy: 70.0),
            status: .unlocked
        ),
        Achievement(
            id: "velocity_sonic",
            type: .velocity,
            difficulty: .silver,
            title: "Sonic",
            description: "Completa un quiz en menos de 15 segundos por pregunta",
            iconName: "timer",
            points: 10,
            criteria: AchievementCriteria.velocity(maxSecondsPerQuestion: 15.0, minAccuracy: 70.0),
            status: .unlocked
        ),
        Achievement(
            id: "velocity_flash",
            type: .velocity,
            difficulty: .silver,
            title: "Flash",
            description: "Completa un quiz en menos de 10 segundos por pregunta",
            iconName: "speedometer",
            points: 15,
            criteria: AchievementCriteria.velocity(maxSecondsPerQuestion: 10.0, minAccuracy: 70.0),
            status: .unlocked
        ),
        
        Achievement(
            id: "precision_punteria",
            type: .precision,
            difficulty: .bronze,
            title: "Puntería",
            description: "Obtén 100% de aciertos en un quiz de 5+ preguntas",
            iconName: "target",
            points: 10,
            criteria: AchievementCriteria.precision(requiredAccuracy: 100.0, minQuestions: 5),
            status: .unlocked
        ),
        Achievement(
            id: "precision_francotirador",
            type: .precision,
            difficulty: .silver,
            title: "Francotirador",
            description: "Obtén 100% de aciertos en 3 quizzes seguidos",
            iconName: "scope",
            points: 20,
            criteria: AchievementCriteria.precisionStreak(requiredStreak: 3, requiredAccuracy: 100.0),
            status: .unlocked
        ),
        Achievement(
            id: "precision_maestro",
            type: .precision,
            difficulty: .gold,
            title: "Maestro Precisión",
            description: "Obtén 100% en un quiz de cada asignatura",
            iconName: "checkmark.seal.fill",
            points: 30,
            criteria: AchievementCriteria.precisionAllSubjects(requiredAccuracy: 100.0),
            status: .unlocked
        ),
        
        Achievement(
            id: "consistency_dedicado",
            type: .consistency,
            difficulty: .bronze,
            title: "Dedicado",
            description: "Mantén una racha de 3 días consecutivos",
            iconName: "flame.fill",
            points: 5,
            criteria: AchievementCriteria.consistency(requiredDays: 3),
            status: .unlocked
        ),
        Achievement(
            id: "consistency_disciplinado",
            type: .consistency,
            difficulty: .silver,
            title: "Disciplinado",
            description: "Mantén una racha de 7 días consecutivos",
            iconName: "calendar.badge.plus",
            points: 15,
            criteria: AchievementCriteria.consistency(requiredDays: 7),
            status: .unlocked
        ),
        Achievement(
            id: "consistency_imparable",
            type: .consistency,
            difficulty: .gold,
            title: "Imparable",
            description: "Mantén una racha de 15 días consecutivos",
            iconName: "chart.line.uptrend.xyaxis",
            points: 30,
            criteria: AchievementCriteria.consistency(requiredDays: 15),
            status: .unlocked
        ),
        
        Achievement(
            id: "explorer_curioso",
            type: .explorer,
            difficulty: .bronze,
            title: "Curioso",
            description: "Completa quizzes de 2 asignaturas diferentes",
            iconName: "map.fill",
            points: 5,
            criteria: AchievementCriteria.explorer(requiredSubjects: 2),
            status: .unlocked
        ),
        Achievement(
            id: "explorer_aventurero",
            type: .explorer,
            difficulty: .bronze,
            title: "Aventurero",
            description: "Completa quizzes de 3 asignaturas diferentes",
            iconName: "compass.drawing",
            points: 10,
            criteria: AchievementCriteria.explorer(requiredSubjects: 3),
            status: .unlocked
        ),
        Achievement(
            id: "explorer_conquistador",
            type: .explorer,
            difficulty: .silver,
            title: "Conquistador",
            description: "Completa al menos un quiz de cada asignatura",
            iconName: "globe.americas.fill",
            points: 25,
            criteria: AchievementCriteria.explorer(requiredSubjects: 4), // Asumiendo 4 asignaturas
            status: .unlocked
        ),
        
        Achievement(
            id: "perfectionist_persistente",
            type: .perfectionist,
            difficulty: .bronze,
            title: "Persistente",
            description: "Repite un quiz hasta lograr 100% de aciertos",
            iconName: "arrow.clockwise",
            points: 10,
            criteria: AchievementCriteria.perfectionist(requiredPerfectQuizzes: 1, allowRetries: true),
            status: .unlocked
        ),
        Achievement(
            id: "perfectionist_obsesivo",
            type: .perfectionist,
            difficulty: .silver,
            title: "Obsesivo",
            description: "Logra 100% de aciertos en 5 quizzes diferentes",
            iconName: "diamond.fill",
            points: 25,
            criteria: AchievementCriteria.perfectionist(requiredPerfectQuizzes: 5, allowRetries: false),
            status: .unlocked
        ),
        Achievement(
            id: "perfectionist_absoluto",
            type: .perfectionist,
            difficulty: .gold,
            title: "Perfección Absoluta",
            description: "Logra 100% de aciertos + velocidad en un mismo quiz",
            iconName: "crown.fill",
            points: 40,
            criteria: AchievementCriteria.perfectAbsolute(requiredAccuracy: 100.0, maxSecondsPerQuestion: 15.0),
            status: .unlocked
        )
    ]
}

enum AchievementCriteria: Codable, Equatable {
    case velocity(maxSecondsPerQuestion: Double, minAccuracy: Double)
    case precision(requiredAccuracy: Double, minQuestions: Int)
    case precisionStreak(requiredStreak: Int, requiredAccuracy: Double)
    case precisionAllSubjects(requiredAccuracy: Double)
    case consistency(requiredDays: Int)
    case explorer(requiredSubjects: Int)
    case perfectionist(requiredPerfectQuizzes: Int, allowRetries: Bool)
    case perfectAbsolute(requiredAccuracy: Double, maxSecondsPerQuestion: Double)
}
