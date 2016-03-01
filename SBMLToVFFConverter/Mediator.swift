//
//  MediatorProtocol.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 2/29/16.
//  Copyright © 2016 Varnerlab. All rights reserved.
//

import Foundation

protocol Mediator {
    func send(message: String, client: MediatorClient?)
}