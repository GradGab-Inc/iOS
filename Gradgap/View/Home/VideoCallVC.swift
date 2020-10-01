//
//  VideoCallVC.swift
//  Gradgap
//
//  Created by iMac on 10/1/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class VideoCallVC: UIViewController {

    @IBOutlet weak var headerNameLbl: UILabel!
    @IBOutlet weak var headerTimeLbl: UILabel!
    
    @IBOutlet weak var bottomNameLbl: UILabel!
    @IBOutlet weak var collageNameLbl: UILabel!
    
    @IBOutlet weak var microPhoneBtn: Button!
    @IBOutlet weak var callBtn: Button!
    @IBOutlet weak var cameraBtn: Button!
    
    @IBOutlet weak var twoMinuteLeftBackView: UIView!
    
    @IBOutlet weak var mentorTimeExtensionBackView: UIView!
    @IBOutlet weak var mentorMessageLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - configUI
    func configUI() {
        twoMinuteLeftBackView.isHidden = true
        mentorTimeExtensionBackView.isHidden = true
    //    twoMinuteLeftBackView.sainiRoundCorners(.bottomLeft, radius: 15)
        
        if AppModel.shared.currentUser.user?.userType == 1 {
            twoMinuteLeftBackView.isHidden = false
        }
        else if AppModel.shared.currentUser.user?.userType == 2 {
            mentorTimeExtensionBackView.isHidden = false
        }
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCallBtn(_ sender: Any) {
    }
    
    @IBAction func clickToMicrophone(_ sender: Any) {
        
    }
    
    @IBAction func clickToCamera(_ sender: Any) {
        
    }
    
    @IBAction func clickToYes(_ sender: Any) {
        
    }
    
    @IBAction func clickToNo(_ sender: Any) {
        twoMinuteLeftBackView.isHidden = true
    }
    
    @IBAction func clickToReject(_ sender: Any) {
        mentorTimeExtensionBackView.isHidden = true
    }
    
    @IBAction func clickToAccept(_ sender: Any) {
        
    }
    
    
    deinit {
        log.success("VideoCallVC Memory deallocated!")/
    }
    
}
