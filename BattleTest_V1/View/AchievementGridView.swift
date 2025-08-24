//
//  AchievementGridView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

protocol AchievementGridViewDelegate: AnyObject {
    func achievementGridView(_ gridView: AchievementGridView, didTapAchievement achievement: Achievement)
}

class AchievementGridView: UIView {
    
    weak var delegate: AchievementGridViewDelegate?
    private var achievements: [Achievement] = []
    private var achievementViews: [AchievementBadgeView] = []
    
    private let titleLabel = UILabel()
    private let gridStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let gridColumns = 3
    private let badgeSize: CGFloat = 60.0
    private let spacing: CGFloat = 16.0
    
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
        setupScrollView()
        setupGridStackView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "achievements_title".localized(with: 0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupGridStackView() {
        gridStackView.axis = .vertical
        gridStackView.spacing = spacing
        gridStackView.alignment = .center
        gridStackView.distribution = .equalSpacing
        
        contentView.addSubview(gridStackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        gridStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Grid stack view
            gridStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gridStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gridStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gridStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with achievements: [Achievement]) {
        self.achievements = achievements
        updateGrid()
        updateTitle()
    }
    
    private func updateGrid() {
        clearGrid()
        
        let rows = createRows(from: achievements)
        
        for row in rows {
            gridStackView.addArrangedSubview(row)
        }
        
        animateGridAppearance()
    }
    
    private func clearGrid() {
        achievementViews.forEach { $0.removeFromSuperview() }
        achievementViews.removeAll()
        
        gridStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    private func createRows(from achievements: [Achievement]) -> [UIStackView] {
        var rows: [UIStackView] = []
        
        let displayAchievements = Array(achievements.prefix(12))
        
        for i in stride(from: 0, to: displayAchievements.count, by: gridColumns) {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = spacing
            rowStackView.alignment = .center
            rowStackView.distribution = .equalSpacing
            
            let endIndex = min(i + gridColumns, displayAchievements.count)
            let rowAchievements = Array(displayAchievements[i..<endIndex])
            
            for achievement in rowAchievements {
                let badgeView = createAchievementBadge(for: achievement)
                rowStackView.addArrangedSubview(badgeView)
                achievementViews.append(badgeView)
            }
            
            // Agregar spacers si es necesario para mantener alineación
            while rowStackView.arrangedSubviews.count < gridColumns {
                let spacer = UIView()
                spacer.widthAnchor.constraint(equalToConstant: badgeSize).isActive = true
                spacer.heightAnchor.constraint(equalToConstant: badgeSize).isActive = true
                rowStackView.addArrangedSubview(spacer)
            }
            
            rows.append(rowStackView)
        }
        
        return rows
    }
    
    private func createAchievementBadge(for achievement: Achievement) -> AchievementBadgeView {
        let badgeView = AchievementBadgeView()
        badgeView.configure(with: achievement, size: badgeSize)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(badgeTapped(_:)))
        badgeView.addGestureRecognizer(tapGesture)
        badgeView.isUserInteractionEnabled = true
        badgeView.tag = achievements.firstIndex(where: { $0.id == achievement.id }) ?? 0
        
        return badgeView
    }
    
    @objc private func badgeTapped(_ gesture: UITapGestureRecognizer) {
        guard let badgeView = gesture.view as? AchievementBadgeView,
              badgeView.tag < achievements.count else { return }
        
        let achievement = achievements[badgeView.tag]
        
        badgeView.animateTap {
            self.delegate?.achievementGridView(self, didTapAchievement: achievement)
        }
    }
    
    private func updateTitle() {
        let totalCount = achievements.count
        
        if totalCount == 0 {
            titleLabel.text = "no_achievements_yet".localized
        } else {
            titleLabel.text = "achievements_title".localized(with: totalCount)
        }
    }
    
    private func animateGridAppearance() {
        for (index, badgeView) in achievementViews.enumerated() {
            badgeView.alpha = 0.0
            badgeView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(
                withDuration: 0.3,
                delay: Double(index) * 0.05,
                options: [.curveEaseOut],
                animations: {
                    badgeView.alpha = 1.0
                    badgeView.transform = .identity
                }
            )
        }
    }
    
    func animateNewAchievement(achievementId: String) {
        guard let achievement = achievements.first(where: { $0.id == achievementId }),
              let badgeView = achievementViews.first(where: { $0.tag == achievements.firstIndex(where: { $0.id == achievementId }) }) else {
            return
        }
        
        badgeView.configure(with: achievement, size: badgeSize)
        
        badgeView.animateShine()
        
        // Actualizar título
        updateTitle()
    }
    
    override var intrinsicContentSize: CGSize {
        let rows = ceil(Double(min(achievements.count, 12)) / Double(gridColumns))
        let height = CGFloat(rows) * badgeSize + CGFloat(max(0, rows - 1)) * spacing + 80 // +80 para title y padding
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}

class AchievementBadgeView: UIView {
    
    private let iconImageView = UIImageView()
    private let badgeBackgroundView = UIView()
    private let pointsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        badgeBackgroundView.layer.cornerRadius = 30 // Se ajustará con el tamaño
        badgeBackgroundView.layer.borderWidth = 2
        badgeBackgroundView.layer.borderColor = UIColor.systemGray4.cgColor
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.systemGray3
        
        pointsLabel.font = UIFont.boldSystemFont(ofSize: 10)
        pointsLabel.textColor = UIColor.white
        pointsLabel.textAlignment = .center
        pointsLabel.backgroundColor = UIColor.systemBlue
        pointsLabel.layer.cornerRadius = 10
        pointsLabel.layer.masksToBounds = true
        pointsLabel.isHidden = true
        
        pointsLabel.layer.shadowColor = UIColor.black.cgColor
        pointsLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        pointsLabel.layer.shadowRadius = 2
        pointsLabel.layer.shadowOpacity = 0.5
        pointsLabel.layer.masksToBounds = false
        
        addSubview(badgeBackgroundView)
        addSubview(iconImageView)
        addSubview(pointsLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        badgeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Badge background
            badgeBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            badgeBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            badgeBackgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            badgeBackgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: badgeBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: badgeBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalTo: badgeBackgroundView.widthAnchor, multiplier: 0.6),
            iconImageView.heightAnchor.constraint(equalTo: badgeBackgroundView.heightAnchor, multiplier: 0.6),
            
            pointsLabel.topAnchor.constraint(equalTo: badgeBackgroundView.topAnchor, constant: 0),
            pointsLabel.trailingAnchor.constraint(equalTo: badgeBackgroundView.trailingAnchor, constant: 15),
            pointsLabel.widthAnchor.constraint(equalToConstant: 40),
            pointsLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with achievement: Achievement, size: CGFloat) {
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        badgeBackgroundView.layer.cornerRadius = size / 2
        
        iconImageView.image = UIImage(systemName: achievement.iconName)
        
        switch achievement.status {
        case .locked:
            badgeBackgroundView.backgroundColor = UIColor.systemGray6
            badgeBackgroundView.layer.borderColor = UIColor.systemGray4.cgColor
            iconImageView.tintColor = UIColor.systemGray3
            pointsLabel.isHidden = true
            
        case .unlocked:
            badgeBackgroundView.backgroundColor = UIColor.systemBackground
            badgeBackgroundView.layer.borderColor = getColorForDifficulty(achievement.difficulty).cgColor
            iconImageView.tintColor = UIColor.systemGray2
            pointsLabel.isHidden = true
            
        case .earned:
            let color = getColorForDifficulty(achievement.difficulty)
            badgeBackgroundView.backgroundColor = color.withAlphaComponent(0.2)
            badgeBackgroundView.layer.borderColor = color.cgColor
            iconImageView.tintColor = color
            
            // Mostrar puntos - CORREGIDO: Más visible
            pointsLabel.text = "+\(achievement.points)"
            pointsLabel.backgroundColor = color
            pointsLabel.isHidden = false
        }
    }
    
    private func getColorForDifficulty(_ difficulty: AchievementDifficulty) -> UIColor {
        switch difficulty {
        case .bronze: return UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0) // Bronce más visible
        case .silver: return UIColor(red: 0.7, green: 0.7, blue: 0.8, alpha: 1.0) // Plata más visible
        case .gold: return UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)   // Oro más brillante
        }
    }
    
    func animateTap(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = .identity
            }) { _ in
                completion()
            }
        }
    }
    
    func animateShine() {
        let shineView = UIView(frame: bounds)
        shineView.backgroundColor = UIColor.white
        shineView.alpha = 0.0
        shineView.layer.cornerRadius = bounds.width / 2
        addSubview(shineView)
        
        UIView.animate(withDuration: 0.3, animations: {
            shineView.alpha = 0.7
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                shineView.alpha = 0.0
            }) { _ in
                shineView.removeFromSuperview()
            }
        }
    }
}
