//
//  QuizResultsViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class QuizResultsViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let scoreCircleView = UIView()
    private let scoreLabel = UILabel()
    private let percentageLabel = UILabel()
    private let detailsLabel = UILabel()
    private let penaltyLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusLabel = UILabel()
    private let continueButton = UIButton(type: .system)
    
    private let achievementsLabel = UILabel()
    private let achievementsStackView = UIStackView()
    
    private var quizResult: QuizResult!
    private var newAchievements: [Achievement] = []
    
    func configure(with result: QuizResult) {
        self.quizResult = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupUI()
        setupConstraints()
        displayResults()
        saveProgress()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = "results_title".localized
        
        titleLabel.text = "quiz_completed".localized
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .center
        
        scoreCircleView.backgroundColor = UIColor.systemBlue
        scoreCircleView.layer.cornerRadius = 80
        scoreCircleView.clipsToBounds = true
        
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 28)
        scoreLabel.textColor = UIColor.white
        scoreLabel.textAlignment = .center
        
        percentageLabel.font = UIFont.systemFont(ofSize: 16)
        percentageLabel.textColor = UIColor.white
        percentageLabel.textAlignment = .center
        
        detailsLabel.font = UIFont.systemFont(ofSize: 18)
        detailsLabel.textColor = UIColor.label
        detailsLabel.textAlignment = .center
        detailsLabel.numberOfLines = 0
        
        penaltyLabel.font = UIFont.systemFont(ofSize: 16)
        penaltyLabel.textColor = UIColor.systemRed
        penaltyLabel.textAlignment = .center
        
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = UIColor.systemGray
        timeLabel.textAlignment = .center
        
        statusLabel.font = UIFont.boldSystemFont(ofSize: 20)
        statusLabel.textAlignment = .center
        
        achievementsLabel.text = "new_achievements".localized
        achievementsLabel.font = UIFont.boldSystemFont(ofSize: 18)
        achievementsLabel.textColor = UIColor.systemOrange
        achievementsLabel.textAlignment = .center
        achievementsLabel.isHidden = true
        
        achievementsStackView.axis = .vertical
        achievementsStackView.spacing = 8
        achievementsStackView.alignment = .center
        achievementsStackView.isHidden = true
        
        continueButton.setTitle("continue_button".localized, for: .normal)
        continueButton.backgroundColor = UIColor.systemBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        scoreCircleView.addSubview(scoreLabel)
        scoreCircleView.addSubview(percentageLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(scoreCircleView)
        view.addSubview(detailsLabel)
        view.addSubview(penaltyLabel)
        view.addSubview(timeLabel)
        view.addSubview(statusLabel)
        view.addSubview(achievementsLabel)
        view.addSubview(achievementsStackView)
        view.addSubview(continueButton)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreCircleView.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        penaltyLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementsLabel.translatesAutoresizingMaskIntoConstraints = false
        achievementsStackView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreCircleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            scoreCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreCircleView.widthAnchor.constraint(equalToConstant: 160),
            scoreCircleView.heightAnchor.constraint(equalToConstant: 160),
            
            scoreLabel.centerXAnchor.constraint(equalTo: scoreCircleView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreCircleView.centerYAnchor, constant: -10),
            
            percentageLabel.centerXAnchor.constraint(equalTo: scoreCircleView.centerXAnchor),
            percentageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5),
            
            detailsLabel.topAnchor.constraint(equalTo: scoreCircleView.bottomAnchor, constant: 30),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            penaltyLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 15),
            penaltyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            penaltyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timeLabel.topAnchor.constraint(equalTo: penaltyLabel.bottomAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            achievementsLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            achievementsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            achievementsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            achievementsStackView.topAnchor.constraint(equalTo: achievementsLabel.bottomAnchor, constant: 10),
            achievementsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            achievementsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func displayResults() {
        scoreLabel.text = quizResult.scoreDisplay
        percentageLabel.text = "\(Int(quizResult.scorePercentage))%"
        
        detailsLabel.text = "answered_correctly".localized(with: quizResult.score, quizResult.totalQuestions)
        
        penaltyLabel.text = "errors_made".localized(with: quizResult.penaltyCount)
        
        let minutes = Int(quizResult.completionTime) / 60
        let seconds = Int(quizResult.completionTime) % 60
        let timeString = "\(minutes):\(String(format: "%02d", seconds))"
        timeLabel.text = "time_taken".localized(with: timeString)
        
        if quizResult.passed {
            statusLabel.text = "passed".localized
            statusLabel.textColor = UIColor.systemGreen
            scoreCircleView.backgroundColor = UIColor.systemGreen
        } else {
            statusLabel.text = "failed".localized
            statusLabel.textColor = UIColor.systemRed
            scoreCircleView.backgroundColor = UIColor.systemRed
        }
    }
    
    private func saveProgress() {
        let obtainedAchievements = UserProgressManager.shared.processQuizCompletion(quizResult)
        
        self.newAchievements = obtainedAchievements
        
        if !obtainedAchievements.isEmpty {
            displayNewAchievements(obtainedAchievements)
        }
        
        if let user = UserProgressManager.shared.getCurrentUser() {
            print("Quiz procesado - Usuario: \(user.name)")
            print("Total puntos: \(user.totalPoints), Nivel: \(user.level)")
            print("Achievements obtenidos: \(obtainedAchievements.count)")
        }
    }
    
    private func displayNewAchievements(_ achievements: [Achievement]) {
        achievementsLabel.isHidden = false
        achievementsStackView.isHidden = false
        
        achievementsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for achievement in achievements {
            let achievementView = createAchievementRow(for: achievement)
            achievementsStackView.addArrangedSubview(achievementView)
        }
        
        achievementsLabel.alpha = 0.0
        achievementsStackView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [.curveEaseOut], animations: {
            self.achievementsLabel.alpha = 1.0
            self.achievementsStackView.alpha = 1.0
        })
    }
    
    private func createAchievementRow(for achievement: Achievement) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemOrange.cgColor
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: achievement.iconName)
        iconImageView.tintColor = UIColor.systemOrange
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = achievement.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.label
        
        let pointsLabel = UILabel()
        pointsLabel.text = "+\(achievement.points) pts"
        pointsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        pointsLabel.textColor = UIColor.systemOrange
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(pointsLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: pointsLabel.leadingAnchor, constant: -12),
            
            pointsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            pointsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            pointsLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        return containerView
    }
    
    @objc private func continueButtonTapped() {
        updateDashboardIfNeeded()
        
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers.reversed() {
                if viewController is QuizListViewController {
                    navigationController?.popToViewController(viewController, animated: true)
                    return
                }
            }
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func updateDashboardIfNeeded() {
        guard let navigationController = navigationController else { return }
        
        for viewController in navigationController.viewControllers {
            if let dashboardVC = viewController as? DashboardViewController {
                dashboardVC.refreshAfterQuizCompletion()
                
                for achievement in newAchievements {
                    dashboardVC.animateNewAchievement(achievementId: achievement.id)
                }
                
                break
            }
        }
        
        if let tabBarController = navigationController.tabBarController as? MainTabBarController {
            if let dashboardVC = tabBarController.viewControllers?.first as? UINavigationController {
                if let dashboard = dashboardVC.viewControllers.first as? DashboardViewController {
                    dashboard.refreshAfterQuizCompletion()
                    
                    for achievement in newAchievements {
                        dashboard.animateNewAchievement(achievementId: achievement.id)
                    }
                }
            }
        }
    }
}
