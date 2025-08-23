//
//  Subject.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation
import UIKit

struct Subject: Codable {
    let id: String
    let name: String
    let icon: String
    let color: String
    var quizzes: [Quiz]
    
    init(id: String, name: String, icon: String, color: String, quizzes: [Quiz] = []) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.quizzes = quizzes
    }
}

