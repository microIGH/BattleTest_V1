//
//  LocalizationHelper.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 23/08/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}
