//
//  EmailPopupView.swift
//  Gradgap
//
//  Created by iMac on 10/17/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import UIKit

protocol emailPopUpDelegate {
    func getemailPopUp(_ selectedData : String)
}


class EmailPopupView : UIView {
    
    @IBOutlet weak var emailTxt: TextField!
    @IBOutlet weak var submitBtn: Button!
    
    var delegate : emailPopUpDelegate?
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("EmailPopupView", owner: self, options: nil)![0] as! UIView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delay(1.0) {
            self.setUp()
        }
    }
    
    
    func setUp() {
       
    }
    
    
    //MARK: - Button Click
    @IBAction func clickToremoveView(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        guard let email = emailTxt.text else { return }
        
        if email == "" {
            displayToast("Please enter email")
        }
        else {
            delegate?.getemailPopUp(email)
        }
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    
}
