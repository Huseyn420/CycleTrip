//
//  CauseOfError.swift
//  Cycle Trip
//
//  Created by Гусейн Агаев on 10.05.2020.
//  Copyright © 2020 Прогеры. All rights reserved.
//

import Foundation

enum CauseOfError {
    case loginOrPassword
    case shortPassword
    case mailNotFound
    case invalidEmail
    case unknownError
    case serverError
    case entranceFC
}

extension CauseOfError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loginOrPassword:
            return NSLocalizedString("Неверный логин или пароль", comment: "")        case .shortPassword:
            return NSLocalizedString("Пароль должен состоят минимум из 8 символов", comment: "")
        case .mailNotFound:
            return NSLocalizedString("Данная почта не найдена", comment: "")
        case .invalidEmail:
        return NSLocalizedString("Такой почты не существует или она уже привязана к другому аккаунту", comment: "")
        case .unknownError:
            return NSLocalizedString("Непредвиденная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        case .entranceFC:
            return NSLocalizedString("Не удалось войти через Facebook", comment: "")
        }
    }
}
