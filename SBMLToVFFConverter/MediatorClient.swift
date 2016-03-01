//
//  MediatorClient.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 2/29/16.
//  Copyright © 2016 Varnerlab. All rights reserved.
//

import Foundation

class MediatorClient {
    
    var mediator: MessageMediator?
    
    func send(message: String) {
        
        if let local_mediator = mediator {
            local_mediator.send(message, client: self)
        }
    }
    
    func receive(message: String) {
        assert(false, "Method should be overriden")
    }
    
}