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
    var dict : [String : Any] = [String : Any]()
    
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("JoinCallView", owner: self, options: nil)![0] as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
            setUp()
        
    }
    
    func setUp() {
        if dict.count == 0 {
            delay(0) {
                self.setUp()
            }
            return
        }
        
        menteeReminderBackView.isHidden = true
        mentorReminderBackView.isHidden = true
        
        if AppModel.shared.currentUser == nil {
            return
        }
        if AppModel.shared.currentUser.user?.userType == 1 {
            menteeReminderBackView.isHidden = false
            if getDifferenceFromCurrentTimeInMinute((dict["date"] as! String)) == 1 {
                noteLbl.isHidden = true
                menteeTitleLbl.text = "Your call with \(dict["name"] as! String) starts in 1 minute."
            }
            else {
                noteLbl.isHidden = false
                menteeTitleLbl.text = "Your call with \(dict["name"] as! String) starts in 30 minutes."
            }
        }
        else if AppModel.shared.currentUser.user?.userType == 2 {
            mentorReminderBackView.isHidden = false
            if getDifferenceFromCurrentTimeInMinute((dict["date"] as! String)) == 1 {
                mentorTitleLbl.text = "Your video chat with \(dict["name"] as! String) starts in 1 minute."
            }
            else {
                mentorTitleLbl.text = "Your video chat with \(dict["name"] as! String) starts in 30 minutes."
            }
        }
    }
    
    func setupTime() {
        
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
    
//    func minutes(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
//    }
    
    
}

