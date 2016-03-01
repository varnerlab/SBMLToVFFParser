//
//  VLSBMLViewControllerMediatorDelegate.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 2/29/16.
//  Copyright © 2016 Varnerlab. All rights reserved.
//

import Foundation
import Cocoa

class VLSBMLViewControllerMediatorDelegate:MediatorClient {
    
    // instance variable
    let text_field:NSTextView
    
    init(textField:NSTextView) {
        text_field = textField
    }
    
    override func receive(message: String) {
        
        // buffer -
        var buffer = ""
        // get the old string -
        let old_text = text_field.string!
        
        // append the new line -
        buffer+=old_text
        buffer+="\n"
        buffer+=message
        
        // set the new text -
        text_field.string = buffer
        
        // scroll -
        text_field.setNeedsDisplayInRect(text_field.bounds)
    }
}