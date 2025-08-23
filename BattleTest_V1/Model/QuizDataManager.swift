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
    
    func getAllSubjects() -> [Subject] {
        return [
            // BIOLOGÍA - Mantener el quiz existente y agregar uno más
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
            
            // FÍSICA - Nueva asignatura
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
            
            // QUÍMICA - Nueva asignatura
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
            
            // MATEMÁTICAS - Actualizada con quizzes
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
}
