//
//  TableViewCell.swift
//  klear-1
//
//  Created by Yorwos Pallikaropoulos on 12/2/19.
//  Copyright © 2019 Yorwos Pallikaropoulos. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITextFieldDelegate{
    
    
    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
            print("did set")
           
        }
    }
    
    var resignationHandler:(() -> Void)?


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return  true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("\n\n\n\n\n\n\n\nDID END EDITING\n\n\n\n\n\n\n")
    }

    
    func setText(_ text:String){
        textField.text = text
    }
    
 
    
    
    


}
