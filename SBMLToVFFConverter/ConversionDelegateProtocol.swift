//
//  ConversionDelegateProtocol.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 12/16/15.
//  Copyright © 2015 Varnerlab. All rights reserved.
//

import Foundation

protocol ConversionDelegateProtocol {
    
    func execute(input:NSURL, output:NSURL) -> Void
}
