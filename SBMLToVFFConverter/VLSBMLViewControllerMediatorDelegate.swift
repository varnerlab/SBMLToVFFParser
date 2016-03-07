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
    
    func clearConsole() -> Void {
        text_field.string = ""
    }
    
    override func receive(message: String) {
    
        // We are updating the main thread -
        dispatch_async(dispatch_get_main_queue()) {[weak self]() -> Void in
         
            if let weak_self = self {
                
                // buffer -
                var buffer = ""
                
                // get the old string -
                let old_text = weak_self.text_field.string!
                
                // append the new line -
                buffer+=old_text
                buffer+="\n"
                buffer+=message
                
                // set the new text -
                weak_self.text_field.string = buffer
                
                // scroll -
                weak_self.text_field.scrollToEndOfDocument(nil)
                
            }
        }
    }
}