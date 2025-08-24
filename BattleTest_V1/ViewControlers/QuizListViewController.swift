//
//  QuizListViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class QuizListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let progressView = UIProgressView()
    private let progressLabel = UILabel()
    private let headerView = UIView()
    
    private var subject: Subject
    private var quizzes: [Quiz] = []
    
    init(subject: Subject) {
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupConstraints()
        loadQuizzes()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = subject.name
        
        // Header view
        headerView.backgroundColor = UIColor(hex: subject.color) ?? UIColor.systemBlue
        headerView.layer.cornerRadius = 12
        
        // Progress label
        progressLabel.font = UIFont.boldSystemFont(ofSize: 16)
        progressLabel.textColor = UIColor.white
        progressLabel.textAlignment = .center
        
        // Progress view
        progressView.progressTintColor = UIColor.white
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        headerView.addSubview(progressLabel)
        headerView.addSubview(progressView)
        
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        tableView.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        tableView.separatorStyle = .none
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            progressLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            progressLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            progressLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            progressView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadQuizzes() {
        quizzes = subject.quizzes
        updateProgress()
        tableView.reloadData()
    }
    
    private func updateProgress() {
        let completedQuizzes = quizzes.filter { $0.isCompleted }.count
        let totalQuizzes = quizzes.count
        
        if totalQuizzes > 0 {
            let progress = Float(completedQuizzes) / Float(totalQuizzes)
            progressView.progress = progress
            progressLabel.text = "\(completedQuizzes)/\(totalQuizzes) completados"
        } else {
            progressView.progress = 0
            progressLabel.text = "Sin cuestionarios disponibles"
        }
    }
}

extension QuizListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableViewCell
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let quiz = quizzes[indexPath.row]
        
        let quizVC = QuizViewController()
        quizVC.configure(with: quiz, subject: subject)
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

class QuizTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let questionsLabel = UILabel()
    private let statusLabel = UILabel()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor(named: "CardBackground") ?? UIColor.systemGray6
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.label
        titleLabel.numberOfLines = 2
        
        questionsLabel.font = UIFont.systemFont(ofSize: 14)
        questionsLabel.textColor = UIColor.systemGray
        
        statusLabel.font = UIFont.boldSystemFont(ofSize: 24)
        statusLabel.textAlignment = .center
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(questionsLabel)
        containerView.addSubview(statusLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        questionsLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            
            questionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            questionsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            questionsLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -8),
            questionsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            statusLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            statusLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with quiz: Quiz) {
        titleLabel.text = quiz.title
        questionsLabel.text = "\(quiz.questions.count) preguntas"
        
        if quiz.isCompleted {
            statusLabel.text = "✓"
            statusLabel.textColor = UIColor.systemGreen
        } else {
            statusLabel.text = "○"
            statusLabel.textColor = UIColor.systemGray3
        }
    }
}
