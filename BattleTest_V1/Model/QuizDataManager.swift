//
//  QuizDataManager.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation

class QuizDataManager {
    static let shared = QuizDataManager()
    
    private init() {}
    
    // ESPAÑOL - Método original
    func getAllSubjects() -> [Subject] {
        return [
            // BIOLOGÍA
            Subject(
                id: "biologia",
                name: "Biología",
                icon: "🧬",
                color: "#4CAF50",
                quizzes: [
                    Quiz(
                        id: "bio_001",
                        title: "Células y Tejidos",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuántas células tiene aproximadamente un ser humano adulto?",
                                options: ["10-20 billones", "20-30 billones", "30-40 billones", "40-50 billones"],
                                correctAnswer: "30-40 billones"
                            ),
                            Question(
                                question: "¿Cuál es la función principal de los ribosomas?",
                                options: ["Síntesis de proteínas", "Síntesis de lípidos", "Respiración celular", "Fotosíntesis"],
                                correctAnswer: "Síntesis de proteínas"
                            ),
                            Question(
                                question: "¿En qué parte de la célula se encuentra el ADN?",
                                options: ["Citoplasma", "Núcleo", "Mitocondrias", "Ribosomas"],
                                correctAnswer: "Núcleo"
                            ),
                            Question(
                                question: "¿Cuál es la función de las mitocondrias?",
                                options: ["Producir energía", "Sintetizar proteínas", "Almacenar agua", "Proteger la célula"],
                                correctAnswer: "Producir energía"
                            ),
                            Question(
                                question: "¿Qué tipo de células NO tienen núcleo definido?",
                                options: ["Eucariotas", "Procariotas", "Animales", "Vegetales"],
                                correctAnswer: "Procariotas"
                            ),
                            Question(
                                question: "¿Cuál es la función principal de la membrana celular?",
                                options: ["Controlar el paso de sustancias", "Producir energía", "Almacenar información genética", "Sintetizar proteínas"],
                                correctAnswer: "Controlar el paso de sustancias"
                            )
                        ]
                    ),
                    Quiz(
                        id: "bio_002",
                        title: "Genética Básica",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Qué significa ADN?",
                                options: ["Ácido Desoxirribonucleico", "Ácido Ribonucleico", "Antígeno Natural", "Aminoácido Natural"],
                                correctAnswer: "Ácido Desoxirribonucleico"
                            ),
                            Question(
                                question: "¿Cuántos cromosomas tiene una célula humana normal?",
                                options: ["23", "46", "48", "24"],
                                correctAnswer: "46"
                            ),
                            Question(
                                question: "¿Qué es un gen?",
                                options: ["Una proteína", "Un segmento de ADN", "Un tipo de célula", "Una enzima"],
                                correctAnswer: "Un segmento de ADN"
                            ),
                            Question(
                                question: "¿Qué determina el sexo en los humanos?",
                                options: ["Cromosomas XY", "Cromosomas XX", "Ambos", "Ninguno"],
                                correctAnswer: "Ambos"
                            ),
                            Question(
                                question: "¿Qué es la herencia genética?",
                                options: ["Transmisión de características", "Mutación celular", "División celular", "Reproducción asexual"],
                                correctAnswer: "Transmisión de características"
                            )
                        ]
                    )
                ]
            ),
            
            // FÍSICA
            Subject(
                id: "fisica",
                name: "Física",
                icon: "⚡",
                color: "#FF5722",
                quizzes: [
                    Quiz(
                        id: "fis_001",
                        title: "Mecánica Básica",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuál es la unidad de fuerza en el Sistema Internacional?",
                                options: ["Newton", "Joule", "Watt", "Pascal"],
                                correctAnswer: "Newton"
                            ),
                            Question(
                                question: "¿Qué es la velocidad?",
                                options: ["Distancia total recorrida", "Cambio de posición por tiempo", "Fuerza aplicada", "Energía cinética"],
                                correctAnswer: "Cambio de posición por tiempo"
                            ),
                            Question(
                                question: "¿Cuál es la aceleración de la gravedad en la Tierra?",
                                options: ["9.8 m/s²", "10 m/s²", "8.9 m/s²", "11 m/s²"],
                                correctAnswer: "9.8 m/s²"
                            ),
                            Question(
                                question: "¿Qué dice la primera ley de Newton?",
                                options: ["F = ma", "Acción y reacción", "Inercia", "Conservación de energía"],
                                correctAnswer: "Inercia"
                            ),
                            Question(
                                question: "¿Qué es la energía cinética?",
                                options: ["Energía de movimiento", "Energía potencial", "Energía térmica", "Energía química"],
                                correctAnswer: "Energía de movimiento"
                            )
                        ]
                    ),
                    Quiz(
                        id: "fis_002",
                        title: "Electricidad",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuál es la unidad de corriente eléctrica?",
                                options: ["Amperio", "Voltio", "Ohmio", "Watt"],
                                correctAnswer: "Amperio"
                            ),
                            Question(
                                question: "¿Qué es la resistencia eléctrica?",
                                options: ["Oposición al flujo de corriente", "Flujo de electrones", "Diferencia de potencial", "Energía eléctrica"],
                                correctAnswer: "Oposición al flujo de corriente"
                            ),
                            Question(
                                question: "¿Cuál es la ley de Ohm?",
                                options: ["V = I × R", "P = V × I", "E = mc²", "F = ma"],
                                correctAnswer: "V = I × R"
                            ),
                            Question(
                                question: "¿Qué material es buen conductor eléctrico?",
                                options: ["Cobre", "Madera", "Plástico", "Vidrio"],
                                correctAnswer: "Cobre"
                            ),
                            Question(
                                question: "¿Qué es un circuito eléctrico?",
                                options: ["Camino cerrado para corriente", "Generador de electricidad", "Resistencia variable", "Campo magnético"],
                                correctAnswer: "Camino cerrado para corriente"
                            )
                        ]
                    )
                ]
            ),
            
            // QUÍMICA
            Subject(
                id: "quimica",
                name: "Química",
                icon: "🧪",
                color: "#E91E63",
                quizzes: [
                    Quiz(
                        id: "qui_001",
                        title: "Tabla Periódica",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuál es el símbolo químico del oro?",
                                options: ["Au", "Ag", "Or", "Go"],
                                correctAnswer: "Au"
                            ),
                            Question(
                                question: "¿Cuántos protones tiene el carbono?",
                                options: ["6", "12", "14", "8"],
                                correctAnswer: "6"
                            ),
                            Question(
                                question: "¿Qué gas es más abundante en la atmósfera?",
                                options: ["Nitrógeno", "Oxígeno", "CO2", "Argón"],
                                correctAnswer: "Nitrógeno"
                            ),
                            Question(
                                question: "¿Cuál es la fórmula del agua?",
                                options: ["H2O", "CO2", "NaCl", "O2"],
                                correctAnswer: "H2O"
                            ),
                            Question(
                                question: "¿Qué es un átomo?",
                                options: ["Unidad básica de materia", "Tipo de molécula", "Compuesto químico", "Ion positivo"],
                                correctAnswer: "Unidad básica de materia"
                            )
                        ]
                    ),
                    Quiz(
                        id: "qui_002",
                        title: "Enlaces Químicos",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Qué es un enlace iónico?",
                                options: ["Transferencia de electrones", "Compartir electrones", "Atracción magnética", "Repulsión atómica"],
                                correctAnswer: "Transferencia de electrones"
                            ),
                            Question(
                                question: "¿Qué es un enlace covalente?",
                                options: ["Compartir electrones", "Transferir electrones", "Atracción iónica", "Fusión atómica"],
                                correctAnswer: "Compartir electrones"
                            ),
                            Question(
                                question: "¿Cuál es la fórmula de la sal común?",
                                options: ["NaCl", "KCl", "CaCl2", "MgCl2"],
                                correctAnswer: "NaCl"
                            ),
                            Question(
                                question: "¿Qué son los isótopos?",
                                options: ["Átomos con diferente número de neutrones", "Átomos con diferente número de protones", "Moléculas iguales", "Compuestos similares"],
                                correctAnswer: "Átomos con diferente número de neutrones"
                            ),
                            Question(
                                question: "¿Qué es una reacción química?",
                                options: ["Transformación de sustancias", "Mezcla de elementos", "Separación física", "Cambio de estado"],
                                correctAnswer: "Transformación de sustancias"
                            )
                        ]
                    )
                ]
            ),
            
            // MATEMÁTICAS
            Subject(
                id: "matematicas",
                name: "Matemáticas",
                icon: "📐",
                color: "#2196F3",
                quizzes: [
                    Quiz(
                        id: "mat_001",
                        title: "Álgebra Básica",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuál es el resultado de 2x + 3 = 11?",
                                options: ["x = 4", "x = 7", "x = 14", "x = 8"],
                                correctAnswer: "x = 4"
                            ),
                            Question(
                                question: "¿Qué es una ecuación lineal?",
                                options: ["Ecuación de primer grado", "Ecuación de segundo grado", "Ecuación exponencial", "Ecuación logarítmica"],
                                correctAnswer: "Ecuación de primer grado"
                            ),
                            Question(
                                question: "¿Cuál es la pendiente de la recta y = 3x + 2?",
                                options: ["3", "2", "5", "1"],
                                correctAnswer: "3"
                            ),
                            Question(
                                question: "¿Qué es una variable?",
                                options: ["Símbolo que representa un número", "Número constante", "Operación matemática", "Resultado final"],
                                correctAnswer: "Símbolo que representa un número"
                            ),
                            Question(
                                question: "¿Cuál es el resultado de (x + 2)²?",
                                options: ["x² + 4x + 4", "x² + 4", "x² + 2x + 4", "x² + 4x + 2"],
                                correctAnswer: "x² + 4x + 4"
                            )
                        ]
                    ),
                    Quiz(
                        id: "mat_002",
                        title: "Geometría",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "es",
                        questions: [
                            Question(
                                question: "¿Cuál es la fórmula del área de un círculo?",
                                options: ["πr²", "2πr", "πd", "r²"],
                                correctAnswer: "πr²"
                            ),
                            Question(
                                question: "¿Cuántos grados tiene un triángulo?",
                                options: ["180°", "360°", "90°", "270°"],
                                correctAnswer: "180°"
                            ),
                            Question(
                                question: "¿Qué es un polígono regular?",
                                options: ["Lados y ángulos iguales", "Solo lados iguales", "Solo ángulos iguales", "Forma circular"],
                                correctAnswer: "Lados y ángulos iguales"
                            ),
                            Question(
                                question: "¿Cuál es el teorema de Pitágoras?",
                                options: ["a² + b² = c²", "a + b = c", "a × b = c", "a² = b² + c²"],
                                correctAnswer: "a² + b² = c²"
                            ),
                            Question(
                                question: "¿Qué es un ángulo recto?",
                                options: ["90 grados", "180 grados", "45 grados", "360 grados"],
                                correctAnswer: "90 grados"
                            )
                        ]
                    )
                ]
            )
        ]
    }
    
    // MÉTODOS PARA LOCALIZACIÓN
    private func getCurrentLanguage() -> String {
        return NSLocale.preferredLanguages.first?.prefix(2).lowercased() ?? "es"
    }

    func getLocalizedSubjects() -> [Subject] {
        let currentLanguage = getCurrentLanguage()
        
        switch currentLanguage {
        case "en": return getEnglishVersions()
        case "fr": return getFrenchVersions()
        default: return getAllSubjects() // Español
        }
    }

    // VERSIÓN INGLÉS - TODOS LOS QUIZZES
    private func getEnglishVersions() -> [Subject] {
        return [
            // BIOLOGY
            Subject(
                id: "biologia",
                name: "Biology",
                icon: "🧬",
                color: "#4CAF50",
                quizzes: [
                    Quiz(
                        id: "bio_001_en",
                        title: "Cells and Tissues",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "How many cells does an adult human have approximately?",
                                options: ["10-20 billion", "20-30 billion", "30-40 billion", "40-50 billion"],
                                correctAnswer: "30-40 billion"
                            ),
                            Question(
                                question: "What is the main function of ribosomes?",
                                options: ["Protein synthesis", "Lipid synthesis", "Cellular respiration", "Photosynthesis"],
                                correctAnswer: "Protein synthesis"
                            ),
                            Question(
                                question: "Where is DNA found in the cell?",
                                options: ["Cytoplasm", "Nucleus", "Mitochondria", "Ribosomes"],
                                correctAnswer: "Nucleus"
                            ),
                            Question(
                                question: "What is the function of mitochondria?",
                                options: ["Produce energy", "Synthesize proteins", "Store water", "Protect the cell"],
                                correctAnswer: "Produce energy"
                            ),
                            Question(
                                question: "What type of cells do NOT have a defined nucleus?",
                                options: ["Eukaryotes", "Prokaryotes", "Animal cells", "Plant cells"],
                                correctAnswer: "Prokaryotes"
                            ),
                            Question(
                                question: "What is the main function of the cell membrane?",
                                options: ["Control substance passage", "Produce energy", "Store genetic information", "Synthesize proteins"],
                                correctAnswer: "Control substance passage"
                            )
                        ]
                    ),
                    Quiz(
                        id: "bio_002_en",
                        title: "Basic Genetics",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What does DNA stand for?",
                                options: ["Deoxyribonucleic Acid", "Ribonucleic Acid", "Natural Antigen", "Natural Amino Acid"],
                                correctAnswer: "Deoxyribonucleic Acid"
                            ),
                            Question(
                                question: "How many chromosomes does a normal human cell have?",
                                options: ["23", "46", "48", "24"],
                                correctAnswer: "46"
                            ),
                            Question(
                                question: "What is a gene?",
                                options: ["A protein", "A DNA segment", "A type of cell", "An enzyme"],
                                correctAnswer: "A DNA segment"
                            ),
                            Question(
                                question: "What determines sex in humans?",
                                options: ["XY chromosomes", "XX chromosomes", "Both", "Neither"],
                                correctAnswer: "Both"
                            ),
                            Question(
                                question: "What is genetic inheritance?",
                                options: ["Transmission of characteristics", "Cell mutation", "Cell division", "Asexual reproduction"],
                                correctAnswer: "Transmission of characteristics"
                            )
                        ]
                    )
                ]
            ),
            
            // PHYSICS
            Subject(
                id: "fisica",
                name: "Physics",
                icon: "⚡",
                color: "#FF5722",
                quizzes: [
                    Quiz(
                        id: "fis_001_en",
                        title: "Basic Mechanics",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is the unit of force in the International System?",
                                options: ["Newton", "Joule", "Watt", "Pascal"],
                                correctAnswer: "Newton"
                            ),
                            Question(
                                question: "What is velocity?",
                                options: ["Total distance traveled", "Change of position over time", "Applied force", "Kinetic energy"],
                                correctAnswer: "Change of position over time"
                            ),
                            Question(
                                question: "What is the acceleration of gravity on Earth?",
                                options: ["9.8 m/s²", "10 m/s²", "8.9 m/s²", "11 m/s²"],
                                correctAnswer: "9.8 m/s²"
                            ),
                            Question(
                                question: "What does Newton's first law state?",
                                options: ["F = ma", "Action and reaction", "Inertia", "Conservation of energy"],
                                correctAnswer: "Inertia"
                            ),
                            Question(
                                question: "What is kinetic energy?",
                                options: ["Energy of motion", "Potential energy", "Thermal energy", "Chemical energy"],
                                correctAnswer: "Energy of motion"
                            )
                        ]
                    ),
                    Quiz(
                        id: "fis_002_en",
                        title: "Electricity",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is the unit of electric current?",
                                options: ["Ampere", "Volt", "Ohm", "Watt"],
                                correctAnswer: "Ampere"
                            ),
                            Question(
                                question: "What is electrical resistance?",
                                options: ["Opposition to current flow", "Electron flow", "Potential difference", "Electrical energy"],
                                correctAnswer: "Opposition to current flow"
                            ),
                            Question(
                                question: "What is Ohm's law?",
                                options: ["V = I × R", "P = V × I", "E = mc²", "F = ma"],
                                correctAnswer: "V = I × R"
                            ),
                            Question(
                                question: "What material is a good electrical conductor?",
                                options: ["Copper", "Wood", "Plastic", "Glass"],
                                correctAnswer: "Copper"
                            ),
                            Question(
                                question: "What is an electrical circuit?",
                                options: ["Closed path for current", "Electricity generator", "Variable resistance", "Magnetic field"],
                                correctAnswer: "Closed path for current"
                            )
                        ]
                    )
                ]
            ),
            
            // CHEMISTRY
            Subject(
                id: "quimica",
                name: "Chemistry",
                icon: "🧪",
                color: "#E91E63",
                quizzes: [
                    Quiz(
                        id: "qui_001_en",
                        title: "Periodic Table",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is the chemical symbol for gold?",
                                options: ["Au", "Ag", "Or", "Go"],
                                correctAnswer: "Au"
                            ),
                            Question(
                                question: "How many protons does carbon have?",
                                options: ["6", "12", "14", "8"],
                                correctAnswer: "6"
                            ),
                            Question(
                                question: "What gas is most abundant in the atmosphere?",
                                options: ["Nitrogen", "Oxygen", "CO2", "Argon"],
                                correctAnswer: "Nitrogen"
                            ),
                            Question(
                                question: "What is the formula for water?",
                                options: ["H2O", "CO2", "NaCl", "O2"],
                                correctAnswer: "H2O"
                            ),
                            Question(
                                question: "What is an atom?",
                                options: ["Basic unit of matter", "Type of molecule", "Chemical compound", "Positive ion"],
                                correctAnswer: "Basic unit of matter"
                            )
                        ]
                    ),
                    Quiz(
                        id: "qui_002_en",
                        title: "Chemical Bonds",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is an ionic bond?",
                                options: ["Transfer of electrons", "Sharing electrons", "Magnetic attraction", "Atomic repulsion"],
                                correctAnswer: "Transfer of electrons"
                            ),
                            Question(
                                question: "What is a covalent bond?",
                                options: ["Sharing electrons", "Transferring electrons", "Ionic attraction", "Atomic fusion"],
                                correctAnswer: "Sharing electrons"
                            ),
                            Question(
                                question: "What is the formula for common salt?",
                                options: ["NaCl", "KCl", "CaCl2", "MgCl2"],
                                correctAnswer: "NaCl"
                            ),
                            Question(
                                question: "What are isotopes?",
                                options: ["Atoms with different neutron numbers", "Atoms with different proton numbers", "Same molecules", "Similar compounds"],
                                correctAnswer: "Atoms with different neutron numbers"
                            ),
                            Question(
                                question: "What is a chemical reaction?",
                                options: ["Transformation of substances", "Mixing elements", "Physical separation", "State change"],
                                correctAnswer: "Transformation of substances"
                            )
                        ]
                    )
                ]
            ),
            
            // MATHEMATICS
            Subject(
                id: "matematicas",
                name: "Mathematics",
                icon: "📐",
                color: "#2196F3",
                quizzes: [
                    Quiz(
                        id: "mat_001_en",
                        title: "Basic Algebra",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is the result of 2x + 3 = 11?",
                                options: ["x = 4", "x = 7", "x = 14", "x = 8"],
                                correctAnswer: "x = 4"
                            ),
                            Question(
                                question: "What is a linear equation?",
                                options: ["First-degree equation", "Second-degree equation", "Exponential equation", "Logarithmic equation"],
                                correctAnswer: "First-degree equation"
                            ),
                            Question(
                                question: "What is the slope of the line y = 3x + 2?",
                                options: ["3", "2", "5", "1"],
                                correctAnswer: "3"
                            ),
                            Question(
                                question: "What is a variable?",
                                options: ["Symbol representing a number", "Constant number", "Mathematical operation", "Final result"],
                                correctAnswer: "Symbol representing a number"
                            ),
                            Question(
                                question: "What is the result of (x + 2)²?",
                                options: ["x² + 4x + 4", "x² + 4", "x² + 2x + 4", "x² + 4x + 2"],
                                correctAnswer: "x² + 4x + 4"
                            )
                        ]
                    ),
                    Quiz(
                        id: "mat_002_en",
                        title: "Geometry",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "en",
                        questions: [
                            Question(
                                question: "What is the formula for the area of a circle?",
                                options: ["πr²", "2πr", "πd", "r²"],
                                correctAnswer: "πr²"
                            ),
                            Question(
                                question: "How many degrees does a triangle have?",
                                options: ["180°", "360°", "90°", "270°"],
                                correctAnswer: "180°"
                            ),
                            Question(
                                question: "What is a regular polygon?",
                                options: ["Equal sides and angles", "Only equal sides", "Only equal angles", "Circular shape"],
                                correctAnswer: "Equal sides and angles"
                            ),
                            Question(
                                question: "What is the Pythagorean theorem?",
                                options: ["a² + b² = c²", "a + b = c", "a × b = c", "a² = b² + c²"],
                                correctAnswer: "a² + b² = c²"
                            ),
                            Question(
                                question: "What is a right angle?",
                                options: ["90 degrees", "180 degrees", "45 degrees", "360 degrees"],
                                correctAnswer: "90 degrees"
                            )
                        ]
                    )
                ]
            )
        ]
    }

    // VERSIÓN FRANCÉS - TODOS LOS QUIZZES
    private func getFrenchVersions() -> [Subject] {
        return [
            // BIOLOGIE
            Subject(
                id: "biologia",
                name: "Biologie",
                icon: "🧬",
                color: "#4CAF50",
                quizzes: [
                    Quiz(
                        id: "bio_001_fr",
                        title: "Cellules et Tissus",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Combien de cellules un humain adulte a-t-il approximativement?",
                                options: ["10-20 milliards", "20-30 milliards", "30-40 milliards", "40-50 milliards"],
                                correctAnswer: "30-40 milliards"
                            ),
                            Question(
                                question: "Quelle est la fonction principale des ribosomes?",
                                options: ["Synthèse des protéines", "Synthèse des lipides", "Respiration cellulaire", "Photosynthèse"],
                                correctAnswer: "Synthèse des protéines"
                            ),
                            Question(
                                question: "Où trouve-t-on l'ADN dans la cellule?",
                                options: ["Cytoplasme", "Noyau", "Mitochondries", "Ribosomes"],
                                correctAnswer: "Noyau"
                            ),
                            Question(
                                question: "Quelle est la fonction des mitochondries?",
                                options: ["Produire de l'énergie", "Synthétiser les protéines", "Stocker l'eau", "Protéger la cellule"],
                                correctAnswer: "Produire de l'énergie"
                            ),
                            Question(
                                question: "Quel type de cellules n'a PAS de noyau défini?",
                                options: ["Eucaryotes", "Procaryotes", "Cellules animales", "Cellules végétales"],
                                correctAnswer: "Procaryotes"
                            ),
                            Question(
                                question: "Quelle est la fonction principale de la membrane cellulaire?",
                                options: ["Contrôler le passage des substances", "Produire de l'énergie", "Stocker l'information génétique", "Synthétiser les protéines"],
                                correctAnswer: "Contrôler le passage des substances"
                            )
                        ]
                    ),
                    Quiz(
                        id: "bio_002_fr",
                        title: "Génétique de Base",
                        subjectId: "biologia",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Que signifie ADN?",
                                options: ["Acide Désoxyribonucléique", "Acide Ribonucléique", "Antigène Naturel", "Acide Aminé Naturel"],
                                correctAnswer: "Acide Désoxyribonucléique"
                            ),
                            Question(
                                question: "Combien de chromosomes une cellule humaine normale a-t-elle?",
                                options: ["23", "46", "48", "24"],
                                correctAnswer: "46"
                            ),
                            Question(
                                question: "Qu'est-ce qu'un gène?",
                                options: ["Une protéine", "Un segment d'ADN", "Un type de cellule", "Une enzyme"],
                                correctAnswer: "Un segment d'ADN"
                            ),
                            Question(
                                question: "Qu'est-ce qui détermine le sexe chez les humains?",
                                options: ["Chromosomes XY", "Chromosomes XX", "Les deux", "Aucun"],
                                correctAnswer: "Les deux"
                            ),
                            Question(
                                question: "Qu'est-ce que l'hérédité génétique?",
                                options: ["Transmission de caractéristiques", "Mutation cellulaire", "Division cellulaire", "Reproduction asexuée"],
                                correctAnswer: "Transmission de caractéristiques"
                            )
                        ]
                    )
                ]
            ),
            
            // PHYSIQUE
            Subject(
                id: "fisica",
                name: "Physique",
                icon: "⚡",
                color: "#FF5722",
                quizzes: [
                    Quiz(
                        id: "fis_001_fr",
                        title: "Mécanique de Base",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Quelle est l'unité de force dans le Système International?",
                                options: ["Newton", "Joule", "Watt", "Pascal"],
                                correctAnswer: "Newton"
                            ),
                            Question(
                                question: "Qu'est-ce que la vitesse?",
                                options: ["Distance totale parcourue", "Changement de position par temps", "Force appliquée", "Énergie cinétique"],
                                correctAnswer: "Changement de position par temps"
                            ),
                            Question(
                                question: "Quelle est l'accélération de la gravité sur Terre?",
                                options: ["9.8 m/s²", "10 m/s²", "8.9 m/s²", "11 m/s²"],
                                correctAnswer: "9.8 m/s²"
                            ),
                            Question(
                                question: "Que dit la première loi de Newton?",
                                options: ["F = ma", "Action et réaction", "Inertie", "Conservation d'énergie"],
                                correctAnswer: "Inertie"
                            ),
                            Question(
                                question: "Qu'est-ce que l'énergie cinétique?",
                                options: ["Énergie de mouvement", "Énergie potentielle", "Énergie thermique", "Énergie chimique"],
                                correctAnswer: "Énergie de mouvement"
                            )
                        ]
                    ),
                    Quiz(
                        id: "fis_002_fr",
                        title: "Électricité",
                        subjectId: "fisica",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Quelle est l'unité du courant électrique?",
                                options: ["Ampère", "Volt", "Ohm", "Watt"],
                                correctAnswer: "Ampère"
                            ),
                            Question(
                                question: "Qu'est-ce que la résistance électrique?",
                                options: ["Opposition au flux de courant", "Flux d'électrons", "Différence de potentiel", "Énergie électrique"],
                                correctAnswer: "Opposition au flux de courant"
                            ),
                            Question(
                                question: "Quelle est la loi d'Ohm?",
                                options: ["V = I × R", "P = V × I", "E = mc²", "F = ma"],
                                correctAnswer: "V = I × R"
                            ),
                            Question(
                                question: "Quel matériau est un bon conducteur électrique?",
                                options: ["Cuivre", "Bois", "Plastique", "Verre"],
                                correctAnswer: "Cuivre"
                            ),
                            Question(
                                question: "Qu'est-ce qu'un circuit électrique?",
                                options: ["Chemin fermé pour le courant", "Générateur d'électricité", "Résistance variable", "Champ magnétique"],
                                correctAnswer: "Chemin fermé pour le courant"
                            )
                        ]
                    )
                ]
            ),
            
            // CHIMIE
            Subject(
                id: "quimica",
                name: "Chimie",
                icon: "🧪",
                color: "#E91E63",
                quizzes: [
                    Quiz(
                        id: "qui_001_fr",
                        title: "Tableau Périodique",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Quel est le symbole chimique de l'or?",
                                options: ["Au", "Ag", "Or", "Go"],
                                correctAnswer: "Au"
                            ),
                            Question(
                                question: "Combien de protons le carbone a-t-il?",
                                options: ["6", "12", "14", "8"],
                                correctAnswer: "6"
                            ),
                            Question(
                                question: "Quel gaz est le plus abondant dans l'atmosphère?",
                                options: ["Azote", "Oxygène", "CO2", "Argon"],
                                correctAnswer: "Azote"
                            ),
                            Question(
                                question: "Quelle est la formule de l'eau?",
                                options: ["H2O", "CO2", "NaCl", "O2"],
                                correctAnswer: "H2O"
                            ),
                            Question(
                                question: "Qu'est-ce qu'un atome?",
                                options: ["Unité de base de la matière", "Type de molécule", "Composé chimique", "Ion positif"],
                                correctAnswer: "Unité de base de la matière"
                            )
                        ]
                    ),
                    Quiz(
                        id: "qui_002_fr",
                        title: "Liaisons Chimiques",
                        subjectId: "quimica",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Qu'est-ce qu'une liaison ionique?",
                                options: ["Transfert d'électrons", "Partage d'électrons", "Attraction magnétique", "Répulsion atomique"],
                                correctAnswer: "Transfert d'électrons"
                            ),
                            Question(
                                question: "Qu'est-ce qu'une liaison covalente?",
                                options: ["Partage d'électrons", "Transfert d'électrons", "Attraction ionique", "Fusion atomique"],
                                correctAnswer: "Partage d'électrons"
                            ),
                            Question(
                                question: "Quelle est la formule du sel commun?",
                                options: ["NaCl", "KCl", "CaCl2", "MgCl2"],
                                correctAnswer: "NaCl"
                            ),
                            Question(
                                question: "Que sont les isotopes?",
                                options: ["Atomes avec différents nombres de neutrons", "Atomes avec différents nombres de protons", "Mêmes molécules", "Composés similaires"],
                                correctAnswer: "Atomes avec différents nombres de neutrons"
                            ),
                            Question(
                                question: "Qu'est-ce qu'une réaction chimique?",
                                options: ["Transformation de substances", "Mélange d'éléments", "Séparation physique", "Changement d'état"],
                                correctAnswer: "Transformation de substances"
                            )
                        ]
                    )
                ]
            ),
            
            // MATHÉMATIQUES
            Subject(
                id: "matematicas",
                name: "Mathématiques",
                icon: "📐",
                color: "#2196F3",
                quizzes: [
                    Quiz(
                        id: "mat_001_fr",
                        title: "Algèbre de Base",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Quel est le résultat de 2x + 3 = 11?",
                                options: ["x = 4", "x = 7", "x = 14", "x = 8"],
                                correctAnswer: "x = 4"
                            ),
                            Question(
                                question: "Qu'est-ce qu'une équation linéaire?",
                                options: ["Équation du premier degré", "Équation du second degré", "Équation exponentielle", "Équation logarithmique"],
                                correctAnswer: "Équation du premier degré"
                            ),
                            Question(
                                question: "Quelle est la pente de la droite y = 3x + 2?",
                                options: ["3", "2", "5", "1"],
                                correctAnswer: "3"
                            ),
                            Question(
                                question: "Qu'est-ce qu'une variable?",
                                options: ["Symbole représentant un nombre", "Nombre constant", "Opération mathématique", "Résultat final"],
                                correctAnswer: "Symbole représentant un nombre"
                            ),
                            Question(
                                question: "Quel est le résultat de (x + 2)²?",
                                options: ["x² + 4x + 4", "x² + 4", "x² + 2x + 4", "x² + 4x + 2"],
                                correctAnswer: "x² + 4x + 4"
                            )
                        ]
                    ),
                    Quiz(
                        id: "mat_002_fr",
                        title: "Géométrie",
                        subjectId: "matematicas",
                        minQuestionsNumber: 5,
                        language: "fr",
                        questions: [
                            Question(
                                question: "Quelle est la formule de l'aire d'un cercle?",
                                options: ["πr²", "2πr", "πd", "r²"],
                                correctAnswer: "πr²"
                            ),
                            Question(
                                question: "Combien de degrés un triangle a-t-il?",
                                options: ["180°", "360°", "90°", "270°"],
                                correctAnswer: "180°"
                            ),
                            Question(
                                question: "Qu'est-ce qu'un polygone régulier?",
                                options: ["Côtés et angles égaux", "Seulement côtés égaux", "Seulement angles égaux", "Forme circulaire"],
                                correctAnswer: "Côtés et angles égaux"
                            ),
                            Question(
                                question: "Quel est le théorème de Pythagore?",
                                options: ["a² + b² = c²", "a + b = c", "a × b = c", "a² = b² + c²"],
                                correctAnswer: "a² + b² = c²"
                            ),
                            Question(
                                question: "Qu'est-ce qu'un angle droit?",
                                options: ["90 degrés", "180 degrés", "45 degrés", "360 degrés"],
                                correctAnswer: "90 degrés"
                            )
                        ]
                    )
                ]
            )
        ]
    }
}
