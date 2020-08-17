//
//  TextField.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

//@IBDesignable
 class TextField: UITextField {
    
    @IBInspectable var textColorTypeAdapter : Int32 = 0 {
        didSet {
            self.textColorType = ColorType(rawValue: self.textColorTypeAdapter)
        }
    }
    var textColorType : ColorType? {
        didSet {
            self.textColor = textColorType?.value
        }
    }
    
    @IBInspectable var borderColorTypeAdapter : Int32 = 0 {
        didSet {
            self.borderColorType = ColorType(rawValue: self.borderColorTypeAdapter)
        }
    }
    
    var borderColorType : ColorType? {
        didSet {
            setBorderColor(borderColorType: borderColorType)
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var placeholderColorString : String = "" {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholderColorString, attributes: [NSAttributedString.Key.foregroundColor: WhiteColor])
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            setCornerRadius(cornerRadius)
        }
    }
    
    @IBInspectable var backGroundColorTypeAdapter : Int32 = 0 {
        didSet {
            self.backgroundColorType = ColorType(rawValue: self.backGroundColorTypeAdapter)
        }
    }
    var backgroundColorType : ColorType? {
        didSet {
            setBackgroundColor(backgroundColorType: backgroundColorType)
        }
    }
    
    @IBInspectable var leftPadding : CGFloat = 0 {
        didSet {
            if(leftPadding != 0){
                let leftView = UIView()
                leftView.frame = CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height)
                
                self.leftView = leftView
                self.leftViewMode = .always
            }
        }
    }
    
    @IBInspectable var rightPadding : CGFloat = 0 {
        didSet {
            if(rightPadding != 0){
                let leftView = UIView()
                leftView.frame = CGRect(x: 0, y: 0, width: rightPadding, height: self.frame.height)
                
                self.rightView = leftView
                self.rightViewMode = .always
            }
        }
    }
    
    @IBInspectable var isPasteDisable : Bool = false {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.width))
//        self.leftViewMode = UITextFieldViewMode.always
//        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
//        self.rightViewMode = UITextFieldViewMode.always
    }
    /*
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        createBorder()
    }

    func createBorder(){

        let errorImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        errorImg.image = UIImage(named: "caution")
        errorImg.contentMode = UIView.ContentMode.left

        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.masksToBounds = true

        let gapLabel = UIView (frame: CGRect(x: 60, y: 0, width: 15, height: 15))
        self.leftView = gapLabel
        self.leftViewMode = UITextField.ViewMode.always

        /* Display that one when validation is failed */
        self.rightView = errorImg;
        self.rightViewMode = UITextField.ViewMode.always
    }
    */
}
