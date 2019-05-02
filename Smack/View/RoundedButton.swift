//
//  RoundedButton.swift
//  Smack
//
//  Created by Kadir Kutluhan Alev on 29.04.2019.
//  Copyright © 2019 Jonny B. All rights reserved.
//

import UIKit


@IBDesignable
class RoundedButton: UIButton {

    
    @IBInspectable var cornerRadius : CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
