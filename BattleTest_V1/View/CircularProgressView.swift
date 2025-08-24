//
//  CircularProgressView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class CircularProgressView: UIView {
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let centerLabel = UILabel()
    private let levelLabel = UILabel()
    private let pointsLabel = UILabel()
    
    private var progress: Float = 0.0
    private var currentLevel: Int = 1
    private var experienceNeeded: Int = 0
    
    private let lineWidth: CGFloat = 8.0
    private let radius: CGFloat = 60.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.clear
        setupLayers()
        setupLabels()
        setupConstraints()
    }
    
    private func setupLayers() {
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray4.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
    }
    
    private func setupLabels() {
        centerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        centerLabel.textColor = UIColor.label
        centerLabel.textAlignment = .center
        centerLabel.text = "Nivel 1"
        
        pointsLabel.font = UIFont.systemFont(ofSize: 12)
        pointsLabel.textColor = UIColor.secondaryLabel
        pointsLabel.textAlignment = .center
        pointsLabel.text = "100 pts para siguiente nivel"
        pointsLabel.numberOfLines = 2
        
        addSubview(centerLabel)
        addSubview(pointsLabel)
    }
    
    private func setupConstraints() {
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            centerLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
            
            pointsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            pointsLabel.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 5),
            pointsLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -20)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerPaths()
    }
    
    private func updateLayerPaths() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (2 * CGFloat.pi)
        
        let backgroundPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        backgroundLayer.path = backgroundPath.cgPath
        
        let progressPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        progressLayer.path = progressPath.cgPath
    }
    
    func configure(level: Int, progress: Float, experienceNeeded: Int, animated: Bool = true) {
        self.currentLevel = level
        self.progress = max(0.0, min(1.0, progress))
        self.experienceNeeded = experienceNeeded
        
        updateLabels()
        updateProgress(animated: animated)
        updateColors()
    }
    
    private func updateLabels() {
        centerLabel.text = "level".localized(with: currentLevel)
        
        if experienceNeeded > 0 {
            pointsLabel.text = "level_progress".localized(with: experienceNeeded)
        } else {
            pointsLabel.text = "level_max".localized
        }
    }
    
    private func updateProgress(animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = progress
            animation.duration = 1.0
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
    private func updateColors() {
        let progressColor = getColorForLevel(currentLevel)
        progressLayer.strokeColor = progressColor.cgColor
        
        // Actualizar color del texto
        centerLabel.textColor = progressColor
    }
    
    private func getColorForLevel(_ level: Int) -> UIColor {
        switch level {
        case 1...2:
            return UIColor.systemGreen
        case 3...5:
            return UIColor.systemBlue
        case 6...10:
            return UIColor.systemPurple
        case 11...20:
            return UIColor.systemOrange
        default:
            return UIColor.systemYellow
        }
    }
    
    func animateLevelUp(from oldLevel: Int, to newLevel: Int, completion: @escaping () -> Void) {
        let completeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        completeAnimation.fromValue = progressLayer.strokeEnd
        completeAnimation.toValue = 1.0
        completeAnimation.duration = 0.5
        completeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flashEffect()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.centerLabel.text = "Nivel \(newLevel)"
                self.updateColors()
                self.progressLayer.strokeEnd = 0.0
                self.updateProgress(animated: true)
                
                completion()
            }
        }
        
        progressLayer.add(completeAnimation, forKey: "levelUpAnimation")
    }
    
    private func flashEffect() {
        let flashView = UIView(frame: bounds)
        flashView.backgroundColor = UIColor.white
        flashView.alpha = 0.0
        flashView.layer.cornerRadius = radius + lineWidth
        addSubview(flashView)
        
        UIView.animate(withDuration: 0.2, animations: {
            flashView.alpha = 0.8
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                flashView.alpha = 0.0
            }) { _ in
                flashView.removeFromSuperview()
            }
        }
    }
    
    func reset() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        configure(level: 1, progress: 0.0, experienceNeeded: 100, animated: false)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = (radius + lineWidth) * 2 + 20  // +20 para padding del texto
        return CGSize(width: size, height: size)
    }
}
