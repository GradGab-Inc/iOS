//
//  JoinCallView.swift
//  Gradgap
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import UIKit

class JoinCallView: UIView {

    @IBOutlet weak var startsTimeLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    
    var flag : Int = 0
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("JoinCallView", owner: self, options: nil)![0] as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if startsTimeLbl == nil {
            delay(1.0) {
                self.setUp(0)
            }
        }
        else{
            setUp(0)
        }
    }
    
    func setUp(_ flag : Int) {
        if flag == 0 {
            noteLbl.isHidden = false
        }
        else if flag == 1 {
            noteLbl.isHidden = true
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToNotNow(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToJoinNow(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
        
        
    }
}

