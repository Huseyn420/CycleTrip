//
//  SettingsSection.swift
//  Cycle Trip
//
//  Created by AVK on 04.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Social
    case Communications
    
    var description: String{
        switch self {
        case .Social:
            return "Общие"
        case .Communications:
            return "Связь"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType{
    case editProfile
    case editPassword
    case logout
    
    var containsSwitch: Bool {
       return false
    }

    var description: String {
        switch self {
        case .editProfile:
            return "Редактировать фото"
        case .editPassword:
            return "Изменить пароль"
        case .logout:
            return "Выйти из аккаунта"
        }
    }
}

enum CommunicationOptions: Int, CaseIterable, SectionType{
    case biometry
    case reportCrashes
    
    var containsSwitch: Bool {
        switch self {
        case .biometry: return true
        case .reportCrashes: return false
        }
    }


    var description: String{
        switch self {
        case .biometry:
            return "Вход по биометрии"
        case .reportCrashes:
            return "Сообщить об ошибке"
        }
    }
}


