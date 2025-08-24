//
//  WeeklyProgressChart.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class WeeklyProgressChart: UIView {
    
    private var weeklyData: [Int] = Array(repeating: 0, count: 7) // 7 días
    private var barViews: [UIView] = []
    private var valueLabels: [UILabel] = []
    private var dayLabels: [UILabel] = []
    
    private let titleLabel = UILabel()
    private let chartContainerView = UIView()
    private let streakIndicatorView = UIView()
    private let streakLabel = UILabel()
    
    private let maxBarHeight: CGFloat = 60.0
    private let barWidth: CGFloat = 24.0
    private let barSpacing: CGFloat = 12.0
    private let chartInset: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
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
        titleLabel.text = "weekly_activity".localized
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
            //barra
            let barView = UIView()
            barView.backgroundColor = getColorForDay(i)
            barView.layer.cornerRadius = barWidth / 4
            barView.alpha = 0.3
            chartContainerView.addSubview(barView)
            barViews.append(barView)
            
            let valueLabel = UILabel()
            valueLabel.font = UIFont.boldSystemFont(ofSize: 12)
            valueLabel.textColor = UIColor.label
            valueLabel.textAlignment = .center
            valueLabel.text = "0"
            valueLabel.alpha = 0.0
            valueLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            streakIndicatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            streakIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            streakIndicatorView.heightAnchor.constraint(equalToConstant: 32),
            streakIndicatorView.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            chartContainerView.topAnchor.constraint(equalTo: streakIndicatorView.bottomAnchor, constant: 150),
            chartContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: chartInset),
            chartContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -chartInset),
            chartContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            chartContainerView.heightAnchor.constraint(equalToConstant: maxBarHeight + 50)
        ])
        
        setupBarConstraints()
    }
    
    private func setupBarConstraints() {
        for i in 0..<7 {
            let barView = barViews[i]
            let valueLabel = valueLabels[i]
            let dayLabel = dayLabels[i]
            
            barView.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let startOffset = CGFloat(35)
            let xOffset = startOffset + CGFloat(i) * (barWidth + barSpacing)
            
            NSLayoutConstraint.activate([
                barView.leadingAnchor.constraint(equalTo: chartContainerView.leadingAnchor, constant: xOffset),
                barView.widthAnchor.constraint(equalToConstant: barWidth),
                barView.bottomAnchor.constraint(equalTo: chartContainerView.bottomAnchor, constant: -30),
                barView.heightAnchor.constraint(equalToConstant: 4),
                
                valueLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
                valueLabel.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -8), // -8 en lugar de -6
                valueLabel.widthAnchor.constraint(equalToConstant: 24),
                valueLabel.heightAnchor.constraint(equalToConstant: 18),
                
                dayLabel.centerXAnchor.constraint(equalTo: barView.centerXAnchor),
                dayLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 6),
                dayLabel.widthAnchor.constraint(equalToConstant: barWidth)
            ])
        }
    }
    
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
        if streak == 1 {
            streakLabel.text = "streak_text".localized(with: streak)
        } else {
            streakLabel.text = "streak_days".localized(with: streak)
        }
        
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
            return UIColor.systemRed
        }
    }
    
    private func updateBars(animated: Bool) {
        let maxValue = weeklyData.max() ?? 1
        let scale = maxValue > 0 ? maxBarHeight / CGFloat(maxValue) : 0
        
        for i in 0..<7 {
            let value = weeklyData[i]
            let barHeight = max(4, CGFloat(value) * scale)
            let barView = barViews[i]
            let valueLabel = valueLabels[i]
            
            valueLabel.text = value > 0 ? "\(value)" : ""
            
            barView.backgroundColor = value > 0 ? getColorForDay(i) : UIColor.systemGray5
            
            if animated {
                UIView.animate(withDuration: 0.6, delay: Double(i) * 0.1, options: [.curveEaseOut], animations: {
                    barView.constraints.first { $0.firstAttribute == .height }?.constant = barHeight
                    barView.alpha = value > 0 ? 1.0 : 0.3
                    barView.superview?.layoutIfNeeded()
                })
                
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
            return UIColor.systemBlue
        } else if dayIndex < adjustedToday {
            return UIColor.systemGreen
        } else {
            return UIColor.systemGray3
        }
    }
    
    func animateTodayActivity() {
        let today = Calendar.current.component(.weekday, from: Date()) - 2
        let adjustedToday = today < 0 ? 6 : today
        
        guard adjustedToday < barViews.count else { return }
        
        let todayBar = barViews[adjustedToday]
        
        UIView.animate(withDuration: 0.2, animations: {
            todayBar.transform = CGAffineTransform(scaleX: 1.2, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                todayBar.transform = .identity
            })
        }
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 180) // Altura fija
    }
    
    func reset() {
        configure(weeklyData: Array(repeating: 0, count: 7), currentStreak: 0, animated: false)
    }
}
