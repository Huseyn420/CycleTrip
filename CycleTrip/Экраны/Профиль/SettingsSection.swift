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
    case editProfile
    case editPassword
    case logout
    
    var containsSwitch: Bool {
       return false
    }

    var description: String {
        switch self {
        case .editProfile:
            return "Редактировать профиль"
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
    
    var containsSwitch: Bool {
        return false

    }
    var description: String {
    switch self {
    case .email:
             return "Email"
    case .telephonenumbr:
                return "Номер телефона"
                }
    }
}

enum CommunicationOptions: Int, CaseIterable, SectionType{
    case notifications
    case reportCrashes
    
    var containsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .reportCrashes: return false
        }
    }


    var description: String{
        switch self {
        case .notifications:
            return "Уведомления"
        case .reportCrashes:
                 return "Сообщить об ошибке"
        }
    }
}


