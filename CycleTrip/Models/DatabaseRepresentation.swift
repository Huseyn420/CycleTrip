//
//  DatabaseRepresentation.swift
//  CycleTrip
//
//  Created by Vova on 30.05.2020.
//  Copyright © 2020 CycleTrip. All rights reserved.
//

import Foundation

protocol DatabaseRepresentation {
  var representation: [String: Any] { get }
}
