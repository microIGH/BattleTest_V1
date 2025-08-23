//
//  StatsCardView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import UIKit

class StatsCardView: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        valueLabel.font = UIFont.boldSystemFont(ofSize: 24)
        valueLabel.textColor = UIColor.white
        valueLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, value: String, backgroundColor: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        self.backgroundColor = backgroundColor
        
        // ARREGLAR: Colores de texto que se vean en ambos modos
        titleLabel.textColor = UIColor.white
        valueLabel.textColor = UIColor.white
        
        // Agregar sombra para mejor legibilidad
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleLabel.layer.shadowRadius = 1
        titleLabel.layer.shadowOpacity = 0.3
        
        valueLabel.layer.shadowColor = UIColor.black.cgColor
        valueLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        valueLabel.layer.shadowRadius = 1
        valueLabel.layer.shadowOpacity = 0.3
    }
}
