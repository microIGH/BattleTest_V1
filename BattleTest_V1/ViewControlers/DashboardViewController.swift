//
//  DashboardViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let welcomeLabel = UILabel()
    private let totalPointsLabel = UILabel() // NUEVO: Puntuación total grande
    
    // Componentes gamificados
    private let levelProgressView = CircularProgressView()
    private let achievementGridView = AchievementGridView()
    private let weeklyChartView = WeeklyProgressChart()
    
    // Tarjetas de estadísticas rápidas (3 tarjetas)
    private let quickStatsStackView = UIStackView()
    private let totalQuizzesCard = StatsCardView()
    private let averageScoreCard = StatsCardView()
    private let studyTimeCard = StatsCardView()
    
    // MARK: - Properties
    private var dashboardStats: DashboardStats?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // DEBUGGING: Verificar estado del usuario
        if let user = UserProgressManager.shared.getCurrentUser() {
            print("✅ Usuario encontrado: \(user.name)")
            print("🔍 Usuario actual: '\(user.name)' - Email: '\(user.email)'")
            print("📊 Puntos: \(user.totalPoints), Nivel: \(user.level)")
            print("🏆 Achievements: \(user.achievements.count)")
        } else {
            print("❌ No hay usuario registrado - Crear usuario desde Registration")
        }
        
        loadDashboardData()
    }
    
    // MARK: - Setup Methods
    
    /// Configura la interfaz inicial del dashboard
    /// ORIGEN: viewDidLoad necesita configurar UI
    /// PROCESO: Configurar scroll view, labels y componentes gamificados
    /// DESTINO: Dashboard listo para mostrar datos
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = "Dashboard"
        
        setupScrollView()
        setupWelcomeLabel()
        setupTotalPointsLabel() // NUEVO
        setupGameComponents()
        setupQuickStats()
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupWelcomeLabel() {
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        welcomeLabel.textColor = UIColor.label
        welcomeLabel.textAlignment = .left
        welcomeLabel.text = "¡Hola, Estudiante!"
        
        contentView.addSubview(welcomeLabel)
    }
    
    // NUEVO: Setup del label de puntuación total
    private func setupTotalPointsLabel() {
        totalPointsLabel.font = UIFont.boldSystemFont(ofSize: 36)
        totalPointsLabel.textColor = UIColor.systemBlue
        totalPointsLabel.textAlignment = .center
        totalPointsLabel.text = "0 PUNTOS"
        
        contentView.addSubview(totalPointsLabel)
    }
    
    private func setupGameComponents() {
        // Level Progress View
        levelProgressView.backgroundColor = UIColor.systemBackground
        levelProgressView.layer.cornerRadius = 12
        levelProgressView.layer.shadowColor = UIColor.black.cgColor
        levelProgressView.layer.shadowOffset = CGSize(width: 0, height: 2)
        levelProgressView.layer.shadowRadius = 4
        levelProgressView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(levelProgressView)
        contentView.addSubview(achievementGridView)
        contentView.addSubview(weeklyChartView)
    }
    
    private func setupQuickStats() {
        quickStatsStackView.axis = .horizontal
        quickStatsStackView.distribution = .fillEqually
        quickStatsStackView.spacing = 12
        
        contentView.addSubview(quickStatsStackView)
        
        // Solo 3 tarjetas: Quizzes, Promedio, Tiempo
        quickStatsStackView.addArrangedSubview(totalQuizzesCard)
        quickStatsStackView.addArrangedSubview(averageScoreCard)
        quickStatsStackView.addArrangedSubview(studyTimeCard)
    }
    
    private func setupDelegates() {
        achievementGridView.delegate = self
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPointsLabel.translatesAutoresizingMaskIntoConstraints = false // NUEVO
        levelProgressView.translatesAutoresizingMaskIntoConstraints = false
        achievementGridView.translatesAutoresizingMaskIntoConstraints = false
        weeklyChartView.translatesAutoresizingMaskIntoConstraints = false
        quickStatsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // NUEVO: Total Points Label (entre welcome y level progress)
            totalPointsLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            totalPointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            totalPointsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Level Progress View (centrado, ahora debajo del total points)
            levelProgressView.topAnchor.constraint(equalTo: totalPointsLabel.bottomAnchor, constant: 20),
            levelProgressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            levelProgressView.widthAnchor.constraint(equalToConstant: 160),
            levelProgressView.heightAnchor.constraint(equalToConstant: 160),
            
            // Quick Stats (debajo del progreso de nivel)
            quickStatsStackView.topAnchor.constraint(equalTo: levelProgressView.bottomAnchor, constant: 24),
            quickStatsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickStatsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            quickStatsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            // Achievement Grid View - Altura reducida y scroll interno
            achievementGridView.topAnchor.constraint(equalTo: quickStatsStackView.bottomAnchor, constant: 24),
            achievementGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            achievementGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            achievementGridView.heightAnchor.constraint(equalToConstant: 200),
            
            // Weekly Chart View
            weeklyChartView.topAnchor.constraint(equalTo: achievementGridView.bottomAnchor, constant: 24),
            weeklyChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weeklyChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weeklyChartView.heightAnchor.constraint(equalToConstant: 180),
            
            // Content View Bottom
            weeklyChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Loading
    
    /// Carga y actualiza todos los datos del dashboard
    /// ORIGEN: viewWillAppear o después de completar quiz
    /// PROCESO: Obtener stats de UserProgressManager y actualizar todos los componentes
    /// DESTINO: Dashboard actualizado con datos del estudiante actual
    private func loadDashboardData() {
        guard let stats = UserProgressManager.shared.getDashboardStats() else {
            showEmptyState()
            return
        }
        
        self.dashboardStats = stats
        updateUI(with: stats)
    }
    
    private func updateUI(with stats: DashboardStats) {
        // Actualizar welcome label con nombre real del usuario
        if let user = UserProgressManager.shared.getCurrentUser() {
            welcomeLabel.text = "¡Hola, \(user.name)!"
        }
        
        // NUEVO: Actualizar puntuación total grande
        totalPointsLabel.text = "\(stats.totalPoints) PUNTOS"
        
        // Actualizar progreso de nivel
        levelProgressView.configure(
            level: stats.level,
            progress: stats.progressToNextLevel,
            experienceNeeded: stats.experienceNeeded,
            animated: true
        )
        
        // CORREGIDO: Mostrar solo achievements obtenidos en el grid
        if let user = UserProgressManager.shared.getCurrentUser() {
            let earnedAchievements = user.achievements.filter { $0.status == .earned }
            achievementGridView.configure(with: earnedAchievements)
        }
        
        // Actualizar gráfica semanal
        weeklyChartView.configure(
            weeklyData: stats.weeklyActivity,
            currentStreak: stats.currentStreak,
            animated: true
        )
        
        // Actualizar tarjetas de estadísticas rápidas
        updateQuickStats(with: stats)
    }
    
    private func updateQuickStats(with stats: DashboardStats) {
        // Total de quizzes
        totalQuizzesCard.configure(
            title: "Quizzes",
            value: "\(stats.totalQuizzes)",
            backgroundColor: UIColor.systemBlue
        )
        
        // Promedio general
        let averageText = stats.averageScore > 0 ? String(format: "%.0f%%", stats.averageScore) : "0%"
        averageScoreCard.configure(
            title: "Promedio",
            value: averageText,
            backgroundColor: UIColor.systemGreen
        )
        
        // Tiempo de estudio (restaurado)
        let studyTimeText = formatStudyTime(stats.totalStudyTime)
        studyTimeCard.configure(
            title: "Tiempo",
            value: studyTimeText,
            backgroundColor: UIColor.systemPurple
        )
    }
    
    private func formatStudyTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func showEmptyState() {
        welcomeLabel.text = "¡Bienvenido!"
        totalPointsLabel.text = "0 PUNTOS" // NUEVO
        levelProgressView.configure(level: 1, progress: 0.0, experienceNeeded: 100, animated: false)
        achievementGridView.configure(with: []) // Lista vacía para mostrar solo obtenidos
        weeklyChartView.configure(weeklyData: Array(repeating: 0, count: 7), currentStreak: 0, animated: false)
        
        totalQuizzesCard.configure(title: "Quizzes", value: "0", backgroundColor: UIColor.systemBlue)
        averageScoreCard.configure(title: "Promedio", value: "0%", backgroundColor: UIColor.systemGreen)
        studyTimeCard.configure(title: "Tiempo", value: "0m", backgroundColor: UIColor.systemPurple)
    }
    
    // MARK: - Public Methods for External Updates
    
    /// Método público para actualizar el dashboard cuando se completa un quiz
    /// ORIGEN: Llamado desde QuizResultsViewController o similar
    /// PROCESO: Recargar datos y animar cambios relevantes
    /// DESTINO: Dashboard actualizado con nuevos datos
    func refreshAfterQuizCompletion() {
        loadDashboardData()
        
        // Animar actividad de hoy en la gráfica
        weeklyChartView.animateTodayActivity()
        
        // Verificar si hay nuevos achievements para mostrar notificación
        if UserProgressManager.shared.hasNewAchievements() {
            showNewAchievementsBadge()
        }
    }
    
    /// Anima un nuevo achievement obtenido
    /// ORIGEN: Cuando se detecta un nuevo achievement
    /// PROCESO: Animar el badge correspondiente en el grid
    /// DESTINO: Feedback visual de nuevo logro
    func animateNewAchievement(achievementId: String) {
        achievementGridView.animateNewAchievement(achievementId: achievementId)
    }
    
    /// Anima subida de nivel
    /// ORIGEN: Cuando el estudiante sube de nivel
    /// PROCESO: Animación especial en el círculo de progreso
    /// DESTINO: Feedback visual satisfactorio
    func animateLevelUp(from oldLevel: Int, to newLevel: Int) {
        levelProgressView.animateLevelUp(from: oldLevel, to: newLevel) {
            // Reload data después de la animación
            self.loadDashboardData()
        }
    }
    
    private func showNewAchievementsBadge() {
        // Mostrar badge temporal de nuevos achievements
        let badgeView = UIView()
        badgeView.backgroundColor = UIColor.systemOrange
        badgeView.layer.cornerRadius = 8
        badgeView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        
        let badgeLabel = UILabel()
        badgeLabel.text = "!"
        badgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        badgeLabel.textColor = UIColor.white
        badgeLabel.textAlignment = .center
        badgeLabel.frame = badgeView.bounds
        
        badgeView.addSubview(badgeLabel)
        achievementGridView.addSubview(badgeView)
        
        // Posicionar en la esquina superior derecha
        badgeView.frame.origin = CGPoint(
            x: achievementGridView.bounds.width - 24,
            y: 8
        )
        
        // Animar aparición
        badgeView.alpha = 0.0
        badgeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3, animations: {
            badgeView.alpha = 1.0
            badgeView.transform = .identity
        })
        
        // Remover después de 3 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3, animations: {
                badgeView.alpha = 0.0
            }) { _ in
                badgeView.removeFromSuperview()
            }
        }
    }
}

// MARK: - AchievementGridViewDelegate

extension DashboardViewController: AchievementGridViewDelegate {
    
    /// Maneja tap en achievement para mostrar detalles
    /// ORIGEN: Usuario toca un achievement en el grid
    /// PROCESO: Mostrar alert con detalles del achievement
    /// DESTINO: Información detallada del logro
    func achievementGridView(_ gridView: AchievementGridView, didTapAchievement achievement: Achievement) {
        showAchievementDetails(achievement)
    }
    
    private func showAchievementDetails(_ achievement: Achievement) {
        let title = achievement.displayTitle
        var message = achievement.displayDescription
        
        // Agregar información adicional según el estado
        switch achievement.status {
        case .locked:
            message += "\n\n🔒 Este logro aún no está disponible."
            
        case .unlocked:
            message += "\n\n⭐ ¡Completa los requisitos para obtener \(achievement.displayPoints)!"
            
        case .earned:
            if let earnedDate = achievement.earnedDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                message += "\n\n🏆 Obtenido el \(formatter.string(from: earnedDate))"
                message += "\n💰 Recompensa: \(achievement.displayPoints)"
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default))
        
        present(alert, animated: true)
    }
}
