//
//  MessageMediator.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 2/29/16.
//  Copyright © 2016 Varnerlab. All rights reserved.
//

import Foundation

class MessageMediator: Mediator {
    
    // clients -
    private var clients: [MediatorClient] = []
    
    // shared instance -
    static let sharedInstance = MessageMediator()
    
    private init() {
    }
    
    func addColleague(colleague:MediatorClient) {
        
        print(colleague)
        
        clients.append(colleague)
    }
    
    func send(message: String, client: MediatorClient?) {
        
        if let local_client = client {
            
        }
        else {
        
            // broadcast -
            for client in clients {
                client.receive(message)
            }
        }
    }
    
}