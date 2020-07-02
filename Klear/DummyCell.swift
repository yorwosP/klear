//
//  DummyCell.swift
//  klear-1
//
//  Created by Yorwos Pallikaropoulos on 2/15/20.
//  Copyright © 2020 Yorwos Pallikaropoulos. All rights reserved.
//

import UIKit

class DummyCell: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var textField: UITextField!
    
   
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        
        Bundle.main.loadNibNamed("DummyCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        textcolor (of textField) is not animatable, so we'll have to use
//        textLayer = CATextLayer(layer: textField.layer)
//        textLayer.frame = textField.frame
//        textLayer.string = "hello"
//        textLayer.foregroundColor = UIColor.white.cgColor
//
//        self.layer.addSublayer(textLayer)
        
        
        
        
        
        
    }
    
    
    func setBackground(color: UIColor){
        
        self.textField.backgroundColor = color
        self.contentView.backgroundColor = color
    }
}
