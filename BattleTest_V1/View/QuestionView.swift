//
//  QuestionView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

protocol QuestionViewDelegate: AnyObject {
    func questionView(_ questionView: QuestionView, didSelectAnswer answer: String)
}

class QuestionView: UIView {
    
    weak var delegate: QuestionViewDelegate?
    
    private let questionLabel = UILabel()
    private let optionsStackView = UIStackView()
    private var optionButtons: [UIButton] = []
    private var currentOptions: [String] = []
    
    override init(frame: CGRect) {	
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
        
        // Question label (como tu <h3>)
        questionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        questionLabel.textColor = UIColor.label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        
        // Options stack view (como tu <ul>)
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.distribution = .fillEqually
        optionsStackView.alignment = .fill
        
        addSubview(questionLabel)
        addSubview(optionsStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            optionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(question: String, options: [String], selectedAnswer: String?) {
        questionLabel.text = question
        currentOptions = options
        
        optionButtons.forEach { $0.removeFromSuperview() }
        optionButtons.removeAll()
        
        for (index, option) in options.enumerated() {
            let button = createOptionButton(option: option, index: index)
            optionButtons.append(button)
            optionsStackView.addArrangedSubview(button)
        }
        
        if let selectedAnswer = selectedAnswer {
            selectAnswer(selectedAnswer)
        }
    }
    
    private func createOptionButton(option: String, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("○ \(option)", for: .normal)
        button.setTitle("● \(option)", for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        // Color normal
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .selected)
        
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        return button
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        guard let index = optionButtons.firstIndex(of: sender) else { return }
        let selectedOption = currentOptions[index]
        
        optionButtons.forEach { button in
            button.isSelected = false
            button.backgroundColor = UIColor.systemGray6
            button.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
        sender.isSelected = true
        sender.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        
        delegate?.questionView(self, didSelectAnswer: selectedOption)
    }
    
    func selectAnswer(_ answer: String) {
        guard let index = currentOptions.firstIndex(of: answer) else { return }
        let button = optionButtons[index]
        optionButtonTapped(button)
    }
    
    func getSelectedAnswer() -> String? {
        guard let selectedButton = optionButtons.first(where: { $0.isSelected }),
              let index = optionButtons.firstIndex(of: selectedButton) else {
            return nil
        }
        return currentOptions[index]
    }
    
    func hasSelectedAnswer() -> Bool {
        return optionButtons.contains { $0.isSelected }
    }
}
