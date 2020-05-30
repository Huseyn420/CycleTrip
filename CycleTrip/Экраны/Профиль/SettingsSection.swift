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
    case Information
    case Social
    case Communications
    
    var description: String{
        switch self {
        case .Social:
            return "Общие"
        case .Information:
            return "Информация"
        case .Communications:
            return "Связь"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType{
    case editPassword
    case logout
    
    var containsSwitch: Bool {
       return false
    }

    var description: String {
        switch self {
        case .editPassword:
            return "Изменить пароль"
        case .logout:
            return "Выйти из аккаунта"
        }
    }
}

enum InformationOptions: Int, CaseIterable, SectionType{
    case email
    case telephonenumbr
    case editProfile
    
    var containsSwitch: Bool {
        return false

    }
    var description: String {
    switch self {
    case .email:
             return "Email"
    case .telephonenumbr:
            return "Номер телефона"
    case .editProfile:
            return "Редактировать фото"
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


