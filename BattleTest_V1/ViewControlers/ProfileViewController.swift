//
//  ProfileViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 22/08/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    //avatar
    private let headerView = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let levelLabel = UILabel()
    
    private let subjectsProgressView = UIView()
    private let subjectsLabel = UILabel()
    private let progressStackView = UIStackView()
    
    private let achievementsView = UIView()
    private let achievementsLabel = UILabel()
    private let achievementGridView = AchievementGridView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = "profile_title".localized
        
        setupScrollView()
        setupHeader()
        setupSubjectsProgress()
        setupAchievements()
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupHeader() {
        headerView.backgroundColor = UIColor(named: "AccentBlue") ?? UIColor.systemBlue
        headerView.layer.cornerRadius = 16
        contentView.addSubview(headerView)
        
        avatarView.backgroundColor = UIColor.white
        avatarView.layer.cornerRadius = 40
        headerView.addSubview(avatarView)
        
        avatarLabel.font = UIFont.boldSystemFont(ofSize: 32)
        avatarLabel.textColor = UIColor.systemBlue
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = UIColor.white
        headerView.addSubview(nameLabel)
        
        levelLabel.font = UIFont.systemFont(ofSize: 16)
        levelLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        headerView.addSubview(levelLabel)
    }
    
    private func setupSubjectsProgress() {
        subjectsLabel.text = "progress_by_subject".localized
        subjectsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        subjectsLabel.textColor = UIColor.label
        
        progressStackView.axis = .vertical
        progressStackView.spacing = 12
        
        contentView.addSubview(subjectsLabel)
        contentView.addSubview(progressStackView)
    }
    
    private func setupAchievements() {
        achievementsLabel.text = "achievements".localized
        achievementsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        achievementsLabel.textColor = UIColor.label
        
        achievementGridView.delegate = self
        
        contentView.addSubview(achievementsLabel)
        contentView.addSubview(achievementGridView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        subjectsLabel.translatesAutoresizingMaskIntoConstraints = false
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        achievementsLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementGridView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            // Header View
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Avatar View
            avatarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            avatarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            // Avatar Label
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // Level Label
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            levelLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
            levelLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // Subjects Label
            subjectsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            subjectsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subjectsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Progress Stack View
            progressStackView.topAnchor.constraint(equalTo: subjectsLabel.bottomAnchor, constant: 16),
            progressStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Achievements Label
            achievementsLabel.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 30),
            achievementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            achievementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Achievement Grid View
            achievementGridView.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 16),
            achievementGridView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            achievementGridView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            achievementGridView.heightAnchor.constraint(equalToConstant: 200),
            achievementGridView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadUserData() {
        guard let user = UserProgressManager.shared.getCurrentUser() else { return }
        
        avatarLabel.text = String(user.name.prefix(1)).uppercased()
        nameLabel.text = user.name
        levelLabel.text = "level_points".localized(with: user.level, user.totalPoints)
        
        updateSubjectsProgress(user: user)
        
        achievementGridView.configure(with: user.achievements)
    }
    
    private func updateSubjectsProgress(user: Student) {
        progressStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let progress = user.getProgressBySubject()
        
        for (subjectId, data) in progress {
            let subjectView = createSubjectProgressView(
                title: subjectId.capitalized,
                completed: data.completed,
                total: data.total,
                percentage: data.percentage
            )
            progressStackView.addArrangedSubview(subjectView)
        }
    }
    
    private func createSubjectProgressView(title: String, completed: Int, total: Int, percentage: Float) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(named: "CardBackground") ?? UIColor.systemGray6
        container.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        let localizedTitle = getLocalizedSubjectName(title.lowercased())
        titleLabel.text = localizedTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let statsLabel = UILabel()
        statsLabel.text = "quizzes_completed".localized(with: completed, total)
        statsLabel.font = UIFont.systemFont(ofSize: 14)
        statsLabel.textColor = UIColor.secondaryLabel
        
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = percentage / 100.0
        progressBar.progressTintColor = UIColor.systemBlue
        
        let percentageLabel = UILabel()
        percentageLabel.text = String(format: "%.0f%%", percentage)
        percentageLabel.font = UIFont.boldSystemFont(ofSize: 14)
        percentageLabel.textColor = UIColor.systemBlue
        
        container.addSubview(titleLabel)
        container.addSubview(statsLabel)
        container.addSubview(progressBar)
        container.addSubview(percentageLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            statsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            statsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            progressBar.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            progressBar.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -12),
            
            percentageLabel.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        
        return container
    }
}

private func getLocalizedSubjectName(_ subjectId: String) -> String {
    switch subjectId {
    case "fisica": return "physics".localized
    case "biologia": return "biology".localized
    case "matematicas": return "mathematics".localized
    case "quimica": return "chemistry".localized
    default: return subjectId.capitalized
    }
}

extension ProfileViewController: AchievementGridViewDelegate {
    
    func achievementGridView(_ gridView: AchievementGridView, didTapAchievement achievement: Achievement) {
        showAchievementDetails(achievement)
    }
    
    private func showAchievementDetails(_ achievement: Achievement) {
        let title = achievement.displayTitle
        var message = achievement.displayDescription
        
        // Agregar información adicional según el estado
        switch achievement.status {
        case .locked:
            message += "\n\n" + "achievement_locked".localized
            
        case .unlocked:
            message += "\n\n" + "achievement_unlocked".localized(with: achievement.displayPoints)
            
        case .earned:
            if let earnedDate = achievement.earnedDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                message += "\n\n" + "achievement_earned".localized(with: formatter.string(from: earnedDate))
                message += "\n" + "achievement_reward".localized(with: achievement.displayPoints)
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close".localized, style: .default))
        
        present(alert, animated: true)
    }
}
