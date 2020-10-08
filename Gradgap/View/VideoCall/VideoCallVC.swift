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
    
    @IBOutlet var videoCollection: UICollectionView!
    
    var meetingModel: MeetingModel?
    private let logger = ConsoleLogger(name: "VideoCallVC")
//    private let audioVideoFacade: AudioVideoFacade
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - configUI
    func configUI() {
        videoCollection.register(UINib(nibName: "VideoTileCell", bundle: nil), forCellWithReuseIdentifier: "VideoTileCell")
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
        setupUI()

        meetingModel.startMeeting()
        meetingModel.activeMode = .video
        videoCollection.reloadData()
        meetingModel.isLocalVideoActive = true
        
        
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCallBtn(_ sender: Any) {
        meetingModel?.endMeeting()
    }
    
    @IBAction func clickToMicrophone(_ sender: Any) {
        meetingModel?.setMute(isMuted: !microPhoneBtn.isSelected)
    }
    
    @IBAction func clickToCamera(_ sender: Any) {
        meetingModel?.currentMeetingSession.audioVideo.switchCamera()
//        audioVideoFacade.switchCamera()
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
    
    func setupUI() {
        // Video collection view
        videoCollection.delegate = self
        videoCollection.dataSource = self
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
            self?.videoCollection.reloadData()
        }
        meetingModel.videoModel.localVideoUpdatedHandler = { [weak self] in
            self?.videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    deinit {
        log.success("VideoCallVC Memory deallocated!")/
    }
    
}


// MARK: UICollectionViewDelegateFlowLayout

extension VideoCallVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        var width = view.frame.width
        var height = view.frame.height
        if UIApplication.shared.statusBarOrientation.isLandscape {
            height /= 2.0
            width = height / 9.0 * 16.0
        } else {
            height = width / 16.0 * 9.0
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}

// MARK: UICollectionViewDataSource

extension VideoCallVC: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        // Only one section for all video tiles
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let meetingModel = meetingModel else {
            return 0
        }
        return meetingModel.videoModel.videoTileCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let meetingModel = meetingModel, indexPath.item < meetingModel.videoModel.videoTileCount else {
            return UICollectionViewCell()
        }
        let isSelf = indexPath.item == 0
        let videoTileState = meetingModel.videoModel.getVideoTileState(for: indexPath)
        let displayName = meetingModel.getVideoTileDisplayName(for: indexPath)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoTileCellReuseIdentifier, for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }

        cell.updateCell(name: displayName, isSelf: isSelf, videoTileState: videoTileState, tag: indexPath.row)
        cell.delegate = meetingModel.videoModel

        if let tileState = videoTileState {
            if tileState.isLocalTile, meetingModel.isFrontCameraActive {
                cell.videoRenderView.mirror = true
            }
            meetingModel.bind(videoRenderView: cell.videoRenderView, tileId: tileState.tileId)
        } else if isSelf {
            // If the tileState is nil and it's for local video, bind the current cell to the local tile (tileId=0)
            meetingModel.bind(videoRenderView: cell.videoRenderView, tileId: 0)
        }
        return cell
    }
}
