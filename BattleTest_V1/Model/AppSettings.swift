//
//  AppSettings.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import Foundation
import UIKit

struct AppSettings: Codable {
    var isDarkMode: Bool
    var selectedLanguage: String
    var isFirstTime: Bool
    
    static var shared: AppSettings {
        if let data = UserDefaults.standard.data(forKey: "AppSettings"),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            return settings
        }
        return AppSettings(isDarkMode: false, selectedLanguage: "es", isFirstTime: true)
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(data, forKey: "AppSettings")
        }
    }
}
