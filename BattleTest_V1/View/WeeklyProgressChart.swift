//
//  WeeklyProgressChart.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class WeeklyProgressChart: UIView {
    
    // MARK: - Properties
    private var weeklyData: [Int] = Array(repeating: 0, count: 7) // 7 días
    private var barViews: [UIView] = []
    private var valueLabels: [UILabel] = []
    private var dayLabels: [UILabel] = []
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let chartContainerView = UIView()
    private let streakIndicatorView = UIView()
    private let streakLabel = UILabel()
    
    // MARK: - Configuration
    private let maxBarHeight: CGFloat = 60.0 // REDUCIDO para dar más espacio
    private let barWidth: CGFloat = 24.0
    private let barSpacing: CGFloat = 12.0 // AUMENTADO el espaciado
    private let chartInset: CGFloat = 20.0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    
    /// Configura la vista inicial de la gráfica
    /// ORIGEN: Inicialización del componente
    /// PROCESO: Configurar título, contenedor y elementos de la gráfica
    /// DESTINO: Vista lista para mostrar datos semanales
    private func setupView() {
        backgroundColor = UIColor.systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        setupTitleLabel()
        setupStreakIndicator()
        setupChartContainer()
        setupChart()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "📊 Actividad Semanal"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    private func setupStreakIndicator() {
        streakIndicatorView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        streakIndicatorView.layer.cornerRadius = 8
        streakIndicatorView.layer.borderWidth = 1
        streakIndicatorView.layer.borderColor = UIColor.systemOrange.cgColor
        
        streakLabel.text = "🔥 Racha: 0 días"
        streakLabel.font = UIFont.boldSystemFont(ofSize: 14)
        streakLabel.textColor = UIColor.systemOrange
        streakLabel.textAlignment = .center
        
        streakIndicatorView.addSubview(streakLabel)
        addSubview(streakIndicatorView)
        
        // Constraints para streak label
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            streakLabel.centerXAnchor.constraint(equalTo: streakIndicatorView.centerXAnchor),
            streakLabel.centerYAnchor.constraint(equalTo: streakIndicatorView.centerYAnchor),
            streakLabel.leadingAnchor.constraint(greaterThanOrEqualTo: streakIndicatorView.leadingAnchor, constant: 12),
            streakLabel.trailingAnchor.constraint(lessThanOrEqualTo: streakIndicatorView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupChartContainer() {
        chartContainerView.backgroundColor = UIColor.clear
        addSubview(chartContainerView)
    }
    
    private func setupChart() {
        createBars()
        createDayLabels()
    }
    
    private func createBars() {
        barViews.removeAll()
        valueLabels.removeAll()
        
        for i in 0..<7 {
            // Crear barra
            let barView = UIView()
            barView.backgroundColor = getColorForDay(i)
            barView.layer.cornerRadius = barWidth / 4
            barView.alpha = 0.3 // Empezar transparente, se animará después
            chartContainerView.addSubview(barView)
            barViews.append(barView)
            
            // Crear label de valor (encima de la barra) - CORREGIDO
            let valueLabel = UILabel()
            valueLabel.font = UIFont.boldSystemFont(ofSize: 12)
            valueLabel.textColor = UIColor.label
            valueLabel.textAlignment = .center
            valueLabel.text = "0"
            valueLabel.alpha = 0.0
            valueLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8) // Fondo para mejor visibilidad
            valueLabel.layer.cornerRadius = 4
            valueLabel.layer.masksToBounds = true
            chartContainerView.addSubview(valueLabel)
            valueLabels.append(valueLabel)
        }
    }
    
    private func createDayLabels() {
        dayLabels.removeAll()
        
        let dayNames = ["L", "M", "X", "J", "V", "S", "D"]
        
        for i in 0..<7 {
            let dayLabel = UILabel()
            dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            dayLabel.textColor = UIColor.secondaryLabel
            dayLabel.textAlignment = .center
            dayLabel.text = dayNames[i]
            chartContainerView.addSubview(dayLabel)
            dayLabels.append(dayLabel)
        }
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        streakIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        chartContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Streak indicator
            streakIndicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            streakIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            streakIndicatorView.heightAnchor.constraint(equalToConstant: 32),
            streakIndicatorView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // Chart container - MÁS ESPACIO para separar números de racha
            chartContainerView.topAnchor.constraint(equalTo: streakIndicatorView.bottomAnchor, constant: 150),
            chartContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: chartInset),
            chartContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -chartInset),
            chartContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            chartContainerView.heightAnchor.constraint(equalToConstant: maxBarHeight + 50) // +50 para labels arriba y abajo
        ])
        
        setupBarConstraints()
    }
    
    // REEMPLAZAR TODO EL MÉTODO setupBarConstraints() POR:
    private func setupBarConstraints() {
        for i in 0..<7 {
            let barView = barViews[i]
            let valueLabel = valueLabels[i]
            let dayLabel = dayLabels[i]
            
            barView.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // NUEVO: Calcular posición centrada
            let startOffset = CGFloat(35) // Para centrar mejor
            let xOffset = startOffset + CGFloat(i) * (barWidth + barSpacing)
            
            NSLayoutConstraint.activate([
                // Bar view - MEJOR CENTRADO
                barView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: xOffset),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -30),
                barView.heightAnchor.constraint(equalToConstant: 4),
                
                // Value label - MÁS ABAJO para no chocar con "Racha"
                valueLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
                valueLabel.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -8), // -8 en lugar de -6
                valueLabel.widthAnchor.constraint(equalToConstant: 24),
                valueLabel.heightAnchor.constraint(equalToConstant: 18),
                
                // Day label
                dayLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
                dayLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 6),
                dayLabel.widthAnchor.constraint(equalToConstant: barWidth)
            ])
        }
    }
    
    // MARK: - Public Configuration Methods
    
    /// Configura la gráfica con datos semanales
    /// ORIGEN: DashboardViewController con datos de actividad del Student
    /// PROCESO: Actualizar barras con alturas proporcionales y animar cambios
    /// DESTINO: Gráfica visual actualizada con datos de la semana
    func configure(weeklyData: [Int], currentStreak: Int, animated: Bool = true) {
        guard weeklyData.count == 7 else {
            print("⚠️ WeeklyProgressChart: Se esperan exactamente 7 valores")
            return
        }
        
        self.weeklyData = weeklyData
        updateStreakIndicator(currentStreak)
        updateBars(animated: animated)
    }
    
    private func updateStreakIndicator(_ streak: Int) {
        streakLabel.text = "🔥 Racha: \(streak) día\(streak == 1 ? "" : "s")"
        
        // Color dinámico basado en la racha
        let color = getStreakColor(for: streak)
        streakIndicatorView.backgroundColor = color.withAlphaComponent(0.1)
        streakIndicatorView.layer.borderColor = color.cgColor
        streakLabel.textColor = color
    }
    
    private func getStreakColor(for streak: Int) -> UIColor {
        switch streak {
        case 0:
            return UIColor.systemGray
        case 1...2:
            return UIColor.systemOrange
        case 3...6:
            return UIColor.systemBlue
        case 7...14:
            return UIColor.systemPurple
        default:
            return UIColor.systemRed // Fuego intenso
        }
    }
    
    private func updateBars(animated: Bool) {
        let maxValue = weeklyData.max() ?? 1
        let scale = maxValue > 0 ? maxBarHeight / CGFloat(maxValue) : 0
        
        for i in 0..<7 {
            let value = weeklyData[i]
            let barHeight = max(4, CGFloat(value) * scale) // Mínimo 4pts de altura
            let barView = barViews[i]
            let valueLabel = valueLabels[i]
            
            // Actualizar label de valor
            valueLabel.text = value > 0 ? "\(value)" : ""
            
            // Actualizar color de la barra
            barView.backgroundColor = value > 0 ? getColorForDay(i) : UIColor.systemGray5
            
            if animated {
                // Animar altura de la barra
                UIView.animate(withDuration: 0.6, delay: Double(i) * 0.1, options: [.curveEaseOut], animations: {
                    barView.constraints.first { $0.firstAttribute == .height }?.constant = barHeight
                    barView.alpha = value > 0 ? 1.0 : 0.3
                    barView.superview?.layoutIfNeeded()
                })
                
                // Animar aparición del label
                UIView.animate(withDuration: 0.3, delay: Double(i) * 0.1 + 0.3, animations: {
                    valueLabel.alpha = value > 0 ? 1.0 : 0.0
                })
                
            } else {
                barView.constraints.first { $0.firstAttribute == .height }?.constant = barHeight
                barView.alpha = value > 0 ? 1.0 : 0.3
                valueLabel.alpha = value > 0 ? 1.0 : 0.0
            }
        }
    }
    
    private func getColorForDay(_ dayIndex: Int) -> UIColor {
        let today = Calendar.current.component(.weekday, from: Date()) - 2 // Ajustar para que lunes = 0
        let adjustedToday = today < 0 ? 6 : today // Domingo = 6
        
        if dayIndex == adjustedToday {
            return UIColor.systemBlue // Día actual
        } else if dayIndex < adjustedToday {
            return UIColor.systemGreen // Días pasados
        } else {
            return UIColor.systemGray3 // Días futuros
        }
    }
    
    // MARK: - Animation Methods
    
    /// Anima una actualización cuando se completa un quiz hoy
    /// ORIGEN: Cuando el estudiante completa un quiz en el día actual
    /// PROCESO: Actualizar la barra del día actual con animación especial
    /// DESTINO: Feedback visual inmediato de actividad
    func animateTodayActivity() {
        let today = Calendar.current.component(.weekday, from: Date()) - 2
        let adjustedToday = today < 0 ? 6 : today
        
        guard adjustedToday < barViews.count else { return }
        
        let todayBar = barViews[adjustedToday]
        
        // Animación de "pulso" en la barra de hoy
        UIView.animate(withDuration: 0.2, animations: {
            todayBar.transform = CGAffineTransform(scaleX: 1.2, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                todayBar.transform = .identity
            })
        }
    }
    
    // MARK: - Utility Methods
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 180) // Altura fija
    }
    
    /// Resetea la gráfica a estado inicial
    func reset() {
        configure(weeklyData: Array(repeating: 0, count: 7), currentStreak: 0, animated: false)
    }
}
