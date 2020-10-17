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

    @IBOutlet weak var menteeReminderBackView: View!
    @IBOutlet weak var menteeTitleLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    
    @IBOutlet weak var mentorReminderBackView: View!
    @IBOutlet weak var mentorTitleLbl: UILabel!
    
    
    var flag : Int = 0
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("JoinCallView", owner: self, options: nil)![0] as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if menteeTitleLbl == nil {
            delay(1.0) {
                self.setUp()
            }
        }
        else{
            setUp()
        }
    }
    
    func setUp() {
        menteeReminderBackView.isHidden = true
        mentorReminderBackView.isHidden = true
        
        if AppModel.shared.currentUser == nil {
            return
        }
        
        if AppModel.shared.currentUser.user?.userType == 1 {
            menteeReminderBackView.isHidden = false
            noteLbl.isHidden = false
        }
        else if AppModel.shared.currentUser.user?.userType == 2 {
            mentorReminderBackView.isHidden = false
            
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToNotNow(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToMenteeJoinNow(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
        
    }
    
    @IBAction func clickToMentorJoinCall(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
        
        
    }
    
    
    
}

