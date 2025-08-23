//
//  QuizViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class QuizViewController: UIViewController {
    
    // UI Elements (como tu HTML structure)
    private let penaltyDotsView = PenaltyDotsView()
    private let titleLabel = UILabel()
    private let progressView = UIProgressView()
    private let progressLabel = UILabel()
    private let questionView = QuestionView()
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let buttonsStackView = UIStackView()
    
    // Data (como tu JS variables)
    private var quizSession: QuizSession!
    private var quizEngine: QuizEngine!
    
    // CONFIGURACIÓN INICIAL
    func configure(with quiz: Quiz, subject: Subject) {
        quizSession = QuizSession(quiz: quiz, subject: subject)
        quizEngine = QuizEngine(session: quizSession)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupDelegates()
        startQuiz()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        title = quizSession.subject.name
        
        // Title label (como tu #quiz-title)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.systemGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = quizSession.quiz.title
        
        // Progress view (como tu .progress-bar)
        progressView.progressTintColor = UIColor.systemGreen
        progressView.trackTintColor = UIColor.systemGray5
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        // Progress label
        progressLabel.font = UIFont.boldSystemFont(ofSize: 14)
        progressLabel.textColor = UIColor.white
        progressLabel.textAlignment = .center
        progressLabel.backgroundColor = UIColor.systemGreen
        
        // Back button (como tu #back-btn)
        backButton.setTitle("Regresar", for: .normal)
        backButton.backgroundColor = UIColor.systemGray3
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = 8
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Next button (como tu #next-btn)
        nextButton.setTitle("Siguiente", for: .normal)
        nextButton.backgroundColor = UIColor.systemGreen
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        // Buttons stack view (como tu .survey-controller)
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 20
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(nextButton)
        
        view.addSubview(penaltyDotsView)
        view.addSubview(titleLabel)
        view.addSubview(progressView)
        view.addSubview(progressLabel)
        view.addSubview(questionView)
        view.addSubview(buttonsStackView)
    }
    
    private func setupConstraints() {
        penaltyDotsView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            penaltyDotsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            penaltyDotsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            penaltyDotsView.heightAnchor.constraint(equalToConstant: 20),
            penaltyDotsView.widthAnchor.constraint(equalToConstant: 65),
            
            titleLabel.topAnchor.constraint(equalTo: penaltyDotsView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 30),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.topAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            progressLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),
            
            questionView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 30),
            questionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -30),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupDelegates() {
        questionView.delegate = self
    }
    
    // FUNCIÓN startQuiz (como tu JS startQuiz)
    private func startQuiz() {
        updatePenaltyDots()
        showCurrentQuestion()
        updateProgressBar()
        updateButtonStates()
    }
    
    // FUNCIÓN showQuestion (EXACTA DE TU JS)
    private func showCurrentQuestion() {
        let questionIndex = quizSession.currentQuestionIndex
        let questionData = quizSession.selectedQuestions[questionIndex]
        
        // Obtener opciones mezcladas (como tu JS shuffledOptions)
        let shuffledOptions = quizEngine.getShuffledOptions(for: questionIndex)
        
        // Obtener respuesta previa si existe (como tu JS previouslySelectedOption)
        let previousAnswer = quizEngine.getPreviousAnswer(for: questionIndex)
        
        questionView.configure(
            question: questionData.question,
            options: shuffledOptions,
            selectedAnswer: previousAnswer
        )
        
        updateButtonStates()
    }
    
    // FUNCIÓN updateProgressBar (EXACTA DE TU JS)
    private func updateProgressBar() {
        let progress = quizSession.progressPercentage
        let progressPercent = Int(progress * 100)
        
        progressView.progress = progress
        progressLabel.text = "\(progressPercent)%"
    }
    
    private func updatePenaltyDots() {
        penaltyDotsView.updatePenaltyCount(quizSession.penaltyCount)
    }
    
    private func updateButtonStates() {
        // Back button disabled if first question (como tu JS)
        backButton.isEnabled = quizSession.currentQuestionIndex > 0
        backButton.backgroundColor = backButton.isEnabled ? UIColor.systemGray3 : UIColor.systemGray5
        
        // Next button disabled if no answer selected (como tu JS)
        nextButton.isEnabled = questionView.hasSelectedAnswer()
        nextButton.backgroundColor = nextButton.isEnabled ? UIColor.systemGreen : UIColor.systemGray5
    }
    
    // ACTION: Next button (LÓGICA EXACTA DE TU JS next-btn)
    @objc private func nextButtonTapped() {
        guard let selectedOption = questionView.getSelectedAnswer() else { return }
        
        // Procesar respuesta con QuizEngine (tu lógica JS)
        let result = quizEngine.processAnswer(selectedOption)
        
        // Actualizar penalty dots (como tu updatePenaltyDots JS)
        updatePenaltyDots()
        
        // Verificar si se alcanzó el límite de errores (como tu JS)
        if result == .restartRequired {
            showRestartAlert()
            return
        }
        
        // Avanzar a siguiente pregunta
        let nextResult = quizEngine.moveToNextQuestion()
        
        if nextResult == .quizCompleted {
            // Quiz completado, ir a resultados
            showResults()
        } else {
            // Continuar con siguiente pregunta (como tu JS)
            showCurrentQuestion()
            updateProgressBar()
        }
    }
    
    // ACTION: Back button (LÓGICA EXACTA DE TU JS back-btn)
    @objc private func backButtonTapped() {
        if quizSession.currentQuestionIndex > 0 {
            quizEngine.processBackNavigation()
            showCurrentQuestion()
            updateProgressBar()
        }
    }
    
    private func showRestartAlert() {
        let alert = UIAlertController(
            title: "Límite de errores alcanzado",
            message: "Has alcanzado el límite de errores. El cuestionario se reiniciará.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.restartQuiz()
        })
        
        present(alert, animated: true)
    }
    
    private func restartQuiz() {
        quizSession.reset()
        quizEngine = QuizEngine(session: quizSession)
        startQuiz()
    }
    
    private func showResults() {
        let result = QuizResult(session: quizSession)
        let resultsVC = QuizResultsViewController()
        resultsVC.configure(with: result)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

// MARK: - QuestionViewDelegate
extension QuizViewController: QuestionViewDelegate {
    func questionView(_ questionView: QuestionView, didSelectAnswer answer: String) {
        // Habilitar botón siguiente cuando se seleccione una respuesta (como tu JS event listener)
        updateButtonStates()
    }
}
