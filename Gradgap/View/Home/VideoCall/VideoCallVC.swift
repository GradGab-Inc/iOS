//
//  VideoCallVC.swift
//  Gradgap
//
//  Created by iMac on 10/1/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import AmazonChimeSDK
import AVFoundation
import CallKit
import Foundation
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
    
    
    var meetingModel: MeetingModel?
    private let logger = ConsoleLogger(name: "VideoCallVC")
    
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
        
        guard let meetingModel = meetingModel else {
            logger.error(msg: "MeetingModel not set")
            dismiss(animated: true, completion: nil)
            return
        }
        configure(meetingModel: meetingModel)
        super.viewDidLoad()
//        setupUI()

        meetingModel.startMeeting()
        meetingModel.activeMode = .video
        meetingModel.isLocalVideoActive = true
        
        
        
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
    
    private func configure(meetingModel: MeetingModel) {
        meetingModel.notifyHandler = { [weak self] message in
            self?.view?.makeToast(message, duration: 2.0, position: .top)
        }
        meetingModel.isEndedHandler = {
            DispatchQueue.main.async {
                MeetingModule.shared().dismissMeeting(meetingModel)
            }
        }

        meetingModel.videoModel.videoUpdatedHandler = { [weak self] in
            meetingModel.videoModel.resumeAllRemoteVideosInCurrentPageExceptUserPausedVideos()
//            self?.prevVideoPageButton.isEnabled = meetingModel.videoModel.canGoToPrevRemoteVideoPage
//            self?.nextVideoPageButton.isEnabled = meetingModel.videoModel.canGoToNextRemoteVideoPage
//            self?.videoCollection.reloadData()
        }
        meetingModel.videoModel.localVideoUpdatedHandler = { [weak self] in
     //       self?.videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }

    }
    
    deinit {
        log.success("VideoCallVC Memory deallocated!")/
    }
    
}
