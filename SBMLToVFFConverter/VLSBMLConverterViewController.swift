//
//  VLSBMLConverterViewController.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 12/16/15.
//  Copyright © 2015 Varnerlab. All rights reserved.
//

import Cocoa

class VLSBMLConverterViewController: NSViewController {

    // instance variables -
    
    // Outlets -
    @IBOutlet var myGenerateButton:NSButton?
    @IBOutlet var myClearButton:NSButton?
    @IBOutlet var myPopulateSBMLPathButton:NSButton?
    @IBOutlet var myPopulateVFFPathButton:NSButton?
    @IBOutlet var mySBMLFilePathTextField:NSTextField?
    @IBOutlet var myVFFFilePathTextField:NSTextField?
    @IBOutlet var myGenerateConsoleTextField:NSTextView?
    @IBOutlet var myModelTypePopupButton:NSPopUpButton?
    
    
    // data -
    var sbml_file_path:NSURL?
    var vff_file_path:NSURL?
    var mediator_delegate:VLSBMLViewControllerMediatorDelegate?
    
    // delegates -
    var delegate:ConversionDelegateProtocol = SBMLToLFBAFlatFileConversionDelegate()
    
    // build mediator -
    let message_mediator:MessageMediator = MessageMediator.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let local_text_field = myGenerateConsoleTextField {
            
            // user can't edit -
            local_text_field.editable = false
            
            // build the mediator delegate -
            mediator_delegate = VLSBMLViewControllerMediatorDelegate(textField:local_text_field)
            
            if let local_mediator = mediator_delegate {
                
                // add the client -
                message_mediator.addColleague(local_mediator)
            }
        }
    }
    
    
    // MARK:- IBAction methods -
    @IBAction func loadSBMLFilePathAction(sender:NSButton) -> Void {
        
        // Method variables -
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        myFileDialog.canChooseDirectories = false
        myFileDialog.canCreateDirectories = false
        
        // focus on sbml path -
        myFileDialog.becomeFirstResponder()
        
        // completion handler -
        let myCompletionHandler = {[weak self](user_selection:Int) -> Void in
    
            // check the selection -
            if (user_selection == NSFileHandlingPanelOKButton){
                
                // get the URL -
                if let local_path_url = myFileDialog.URL {
                    
                    // get the URL -
                    self?.sbml_file_path = local_path_url
                    
                    // display the URL -
                    let url_string = local_path_url.absoluteString;
                    self?.mySBMLFilePathTextField?.stringValue = url_string
                    
                    // activate generate button?
                    self?.activateMyGenerationButton();
                }
            }
        }
        
        // open as sheet -
        myFileDialog.beginSheetModalForWindow(self.view.window!, completionHandler: myCompletionHandler);
    }
    
    @IBAction func loadVFFFilePathAction(sender:NSButton) -> Void {
        
        // Method variables -
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        myFileDialog.canChooseFiles = false
        myFileDialog.canCreateDirectories = true
        myFileDialog.canChooseDirectories = true
        
        // focus on vff path -
        self.myVFFFilePathTextField?.becomeFirstResponder()
        
        // completion handler -
        let myCompletionHandler = {[weak self](user_selection:Int) -> Void in
            
            // check the selection -
            if (user_selection == NSFileHandlingPanelOKButton){
                
                // get the URL -
                if let local_path_url = myFileDialog.URL {
                    
                    // if we have the URL, grab it for later -
                    self?.vff_file_path = local_path_url
                    
                    // display the URL -
                    let url_string = local_path_url.absoluteString
                    self?.myVFFFilePathTextField?.stringValue = url_string
                    
                    // activate generate button?
                    self?.activateMyGenerationButton();
                }
            }
        }
        
        // open as sheet -
        myFileDialog.beginSheetModalForWindow(self.view.window!, completionHandler: myCompletionHandler);
    }
    
    @IBAction func generateVFFFileFromSBMLFileAction(sender:NSButton) -> Void {
        
        // just in case ... double check to make sure we have he URLs -
        if (self.sbml_file_path != nil && self.vff_file_path != nil){
        
            // clearout the console -
            mediator_delegate?.clearConsole()
            
            // ok, when we implement more delegates, we would have some logic here 
            // to generate the proper delegate, for now just use the default -
            delegate.execute(self.sbml_file_path!, output: self.vff_file_path!)
            
            // KIA the delegate -
            //delegate = nil
        }
    }
    
    @IBAction func clearDataFromAllFieldsAction(sender:NSButton) -> Void {
        
        // clear out the data -
        self.mySBMLFilePathTextField?.stringValue = ""
        self.myVFFFilePathTextField?.stringValue = ""
        self.myGenerateConsoleTextField?.string = ""
        
        // remove url's -
        self.sbml_file_path = nil
        self.vff_file_path = nil
        
        // reset the generate button?
        self.activateMyGenerationButton()
    }
    
    // MARK:- Helper methods -
    func activateMyGenerationButton() -> Void {
        
        // check conditions - both paths are there, then activate button
        if (self.sbml_file_path != nil && self.vff_file_path != nil){
            self.myGenerateButton?.enabled = true
        }
        else {
            self.myGenerateButton?.enabled = false
        }
    }
}
