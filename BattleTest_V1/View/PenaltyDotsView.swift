//
//  PenaltyDotsView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class PenaltyDotsView: UIView {
    
    private let dot1 = UIView()
    private let dot2 = UIView()
    private let dot3 = UIView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDots()
    }
    
    private func setupDots() {
        // Stack view para los puntos
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        // Configurar cada punto (como tu CSS .dot)
        [dot1, dot2, dot3].forEach { dot in
            dot.backgroundColor = UIColor.systemGray4 // Color inicial gris
            dot.layer.cornerRadius = 7.5 // Radio para hacer círculo (15px/2)
            dot.clipsToBounds = true
            
            stackView.addArrangedSubview(dot)
        }
        
        addSubview(stackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Cada punto 15x15 (como tu CSS)
            dot1.widthAnchor.constraint(equalToConstant: 15),
            dot1.heightAnchor.constraint(equalToConstant: 15),
            dot2.widthAnchor.constraint(equalToConstant: 15),
            dot2.heightAnchor.constraint(equalToConstant: 15),
            dot3.widthAnchor.constraint(equalToConstant: 15),
            dot3.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    // FUNCIÓN EXACTA DE TU JS updatePenaltyDots()
    func updatePenaltyCount(_ count: Int) {
        let dots = [dot1, dot2, dot3]
        
        for (index, dot) in dots.enumerated() {
            if index < count {
                // Rojo cuando hay error (como tu CSS .dot.red)
                dot.backgroundColor = UIColor.systemRed
            } else {
                // Gris cuando no hay error
                dot.backgroundColor = UIColor.systemGray4
            }
        }
    }
}
