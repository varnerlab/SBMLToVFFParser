//
//  SBMLToLFBAFlatFileConversionDelegate.swift
//  SBMLToVFFConverter
//
//  Created by Jeffrey Varner on 12/16/15.
//  Copyright © 2015 Varnerlab. All rights reserved.
//

import Cocoa

class SBMLToLFBAFlatFileConversionDelegate: NSObject, ConversionDelegateProtocol {

    // instance variables -
    let message_mediator:MessageMediator = MessageMediator.sharedInstance
    
    // delegate methods -
    func execute(input:NSURL, output:NSURL) -> Void {
    
        // Build XML document -
        var sbml_tree:NSXMLDocument?
        
        do {
            
            // Build sbml_tree -
            sbml_tree = try NSXMLDocument.init(contentsOfURL: input, options:NSXMLDocumentTidyXML)
            
            // Generate buffer -
            let buffer = generateVFFBufferFromSBMLTree(sbml_tree!)
            
            // ok, we have the sbml_tree ... need to write the VFF -
            let output_file_path = (input.URLByDeletingPathExtension?.absoluteString)!+".vff"
            let output_file_name = NSURL(fileURLWithPath: output_file_path).lastPathComponent
            let output_url = output.URLByAppendingPathComponent(output_file_name!, isDirectory: false);
            
            // dump to disk -
            try buffer.writeToURL(output_url, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func generateVFFBufferFromSBMLTree(tree:NSXMLDocument) -> String {
        
        // method variables -
        var buffer:String = ""
        
        do {
            
            // create xpath and grad nodes -
            let reaction_id_xpath = ".//reaction/@id"
            let node_array:[NSXMLNode] = try tree.nodesForXPath(reaction_id_xpath)
            for xml_node in node_array {
                
                // Grab the id = and get the reactants, products and other metadata for this reaction -
                let reaction_name = xml_node.stringValue!
                
                // Get the reactants -
                let reactant_array_xpath = ".//reaction[@id='\(reaction_name)']/listOfReactants/speciesReference"
                let reactant_node_array:[NSXMLNode] = try tree.nodesForXPath(reactant_array_xpath)
                
                // Get the products -
                let product_array_xpath = ".//reaction[@id='\(reaction_name)']/listOfProducts/speciesReference"
                let product_node_array:[NSXMLNode] = try tree.nodesForXPath(product_array_xpath)
                
                // Is this reaction reversible?
                let is_reaction_reversible = try isReactionWithIDReversible(reaction_name,sbml_tree: tree)
                
                // build the fragments -
                let reactant_fragment = try generateReactionFragmentFromSpeciesNodeArray(reactant_node_array)
                let product_fragment = try generateReactionFragmentFromSpeciesNodeArray(product_node_array)
                
                // build the reaction string -
                buffer+=reaction_name
                buffer+=",[],"
                buffer+=reactant_fragment
                buffer+=","
                buffer+=product_fragment
                buffer+=","
                
                if (is_reaction_reversible == true){
                    buffer+="-inf,inf"
                }
                else {
                    buffer+="0,inf"
                }
                
                // end and newline -
                buffer+=";\n"
                
                // message -
                message_mediator.send(reaction_name, client: nil)
            }
        }
        catch {
            print("ERROR: Failed to load the reactions from the SBML file")
        }
        
        
        return buffer
    }
    
    // MARK: private helper methods
    private func isReactionWithIDReversible(reaction_id:String,sbml_tree:NSXMLDocument) throws -> Bool {
    
        // method variables -
        var is_reaction_reversible = true
        
        // xpath for for reversible -
        let xpath_string = ".//reaction[@id='\(reaction_id)']/@reversible"
        let reversible_node:[NSXMLNode] = try sbml_tree.nodesForXPath(xpath_string)
        
        if (reversible_node.count == 1) {
            
            // ok, we have a node, reversible or not?
            let flag = reversible_node.first?.stringValue
            if (flag == "false"){
                is_reaction_reversible = false
            }
        }
        else {
            is_reaction_reversible = false
        }
        
        // return -
        return is_reaction_reversible;
    }
    
    
    private func generateReactionFragmentFromSpeciesNodeArray(node_array:[NSXMLNode]) throws -> String {
        
        // method variables -
        var buffer = ""
        
        // ok, we have a species node array -
        for species_node in node_array {
            
            if let child_node = species_node as? NSXMLElement {
                
                // Get species symbol -
                let species_symbol = child_node.attributeForName("species")?.stringValue!
                
                // Get the stoichiometric coefficient -
                if let stoichiometric_coeffcient = child_node.attributeForName("stoichiometry")?.stringValue {
                 
                    // ok, we have a stochiometric coefficient -
                    buffer+="\(stoichiometric_coeffcient)*\(species_symbol!)+"
                }
                else {
                    
                    // no coefficient -
                    buffer+="\(species_symbol!)+"
                }
            }
        }
        
        
        // return -
        return String(buffer.characters.dropLast())
    }
    
}
