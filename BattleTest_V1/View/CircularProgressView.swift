//
//  CircularProgressView.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 21/08/25.
//

import UIKit

class CircularProgressView: UIView {
    
    // MARK: - UI Components
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let centerLabel = UILabel()
    private let levelLabel = UILabel()
    private let pointsLabel = UILabel()
    
    // MARK: - Properties
    private var progress: Float = 0.0
    private var currentLevel: Int = 1
    private var experienceNeeded: Int = 0
    
    // MARK: - Configuration
    private let lineWidth: CGFloat = 8.0
    private let radius: CGFloat = 60.0
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup Methods
    
    /// Configura la vista inicial
    /// ORIGEN: Inicialización del componente
    /// PROCESO: Configurar capas, labels y constraints
    /// DESTINO: Vista lista para mostrar progreso circular
    private func setupView() {
        backgroundColor = UIColor.clear
        setupLayers()
        setupLabels()
        setupConstraints()
    }
    
    private func setupLayers() {
        // Background circle - ARREGLAR: Usar color adaptativo
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray4.cgColor  // Cambiar de systemGray5 a systemGray4
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        
        // Progress circle (progreso coloreado)
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
    }
    
    private func setupLabels() {
        // Level label (centro, grande)
        centerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        centerLabel.textColor = UIColor.label
        centerLabel.textAlignment = .center
        centerLabel.text = "Nivel 1"
        
        // Points needed label (abajo, pequeño)
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
            // Center label en el centro del círculo
            centerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            centerLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -40),
            
            // Points label debajo del center label
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
        let startAngle = -CGFloat.pi / 2  // Empezar desde arriba
        let endAngle = startAngle + (2 * CGFloat.pi)  // Círculo completo
        
        // Path para el círculo de fondo
        let backgroundPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        backgroundLayer.path = backgroundPath.cgPath
        
        // Path para el círculo de progreso
        let progressPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        progressLayer.path = progressPath.cgPath
    }
    
    // MARK: - Public Configuration Methods
    
    /// Configura el progreso del nivel
    /// ORIGEN: DashboardViewController con datos del Student
    /// PROCESO: Actualizar progress, level, points y animar cambios
    /// DESTINO: Vista actualizada con animación suave
    func configure(level: Int, progress: Float, experienceNeeded: Int, animated: Bool = true) {
        self.currentLevel = level
        self.progress = max(0.0, min(1.0, progress))  // Clamp entre 0 y 1
        self.experienceNeeded = experienceNeeded
        
        updateLabels()
        updateProgress(animated: animated)
        updateColors()
    }
    
    private func updateLabels() {
        centerLabel.text = "Nivel \(currentLevel)"
        
        if experienceNeeded > 0 {
            pointsLabel.text = "\(experienceNeeded) pts para\nsiguiente nivel"
        } else {
            pointsLabel.text = "¡Nivel máximo!"
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
        // Color dinámico basado en el nivel
        let progressColor = getColorForLevel(currentLevel)
        progressLayer.strokeColor = progressColor.cgColor
        
        // Actualizar color del texto
        centerLabel.textColor = progressColor
    }
    
    private func getColorForLevel(_ level: Int) -> UIColor {
        switch level {
        case 1...2:
            return UIColor.systemGreen      // Principiante
        case 3...5:
            return UIColor.systemBlue       // Intermedio
        case 6...10:
            return UIColor.systemPurple     // Avanzado
        case 11...20:
            return UIColor.systemOrange     // Experto
        default:
            return UIColor.systemYellow     // Maestro
        }
    }
    
    // MARK: - Animation Methods
    
    /// Anima un incremento de nivel con efecto especial
    /// ORIGEN: Cuando el estudiante sube de nivel
    /// PROCESO: Animación de "level up" con efectos visuales
    /// DESTINO: Feedback visual satisfactorio para el usuario
    func animateLevelUp(from oldLevel: Int, to newLevel: Int, completion: @escaping () -> Void) {
        // Animación 1: Completar el círculo actual
        let completeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        completeAnimation.fromValue = progressLayer.strokeEnd
        completeAnimation.toValue = 1.0
        completeAnimation.duration = 0.5
        completeAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // Animación 2: Efecto de "flash" cuando se completa
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flashEffect()
            
            // Actualizar al nuevo nivel después del flash
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.centerLabel.text = "Nivel \(newLevel)"
                self.updateColors()
                
                // Resetear progreso y mostrar nuevo progreso
                self.progressLayer.strokeEnd = 0.0
                self.updateProgress(animated: true)
                
                completion()
            }
        }
        
        progressLayer.add(completeAnimation, forKey: "levelUpAnimation")
    }
    
    private func flashEffect() {
        // Efecto de flash blanco
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
    
    // MARK: - Utility Methods
    
    /// Resetea la vista a estado inicial
    func reset() {
        progressLayer.strokeEnd = 0.0
        progressLayer.removeAllAnimations()
        configure(level: 1, progress: 0.0, experienceNeeded: 100, animated: false)
    }
    
    /// Obtiene el tamaño recomendado para la vista
    override var intrinsicContentSize: CGSize {
        let size = (radius + lineWidth) * 2 + 20  // +20 para padding del texto
        return CGSize(width: size, height: size)
    }
}
