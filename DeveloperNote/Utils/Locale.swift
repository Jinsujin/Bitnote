//
//  Locale.swift
//  DeveloperNote
//
//  Created by jsj on 2021/09/02.
//  Copyright © 2021 Tomatoma. All rights reserved.
//

import Foundation

public enum LanguageCodeType: String {
    case korea = "ko"
    case english = "en"
    case japan = "jp"
    
    static func getCode(_ str: String?) -> LanguageCodeType {
        guard let code = str else { return .english }
        
        if let lang = LanguageCodeType.init(rawValue: code) {
            return lang
        }
        return .english
    }
}
