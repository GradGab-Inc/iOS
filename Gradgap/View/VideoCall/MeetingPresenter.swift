//
//  MeetingPresenter.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit
import AmazonChimeSDK
import AmazonChimeSDKMedia

class MeetingPresenter {
//    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var activeMeetingViewController: MeetingViewController?//VideoCallVC?

    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    func showMeetingView(meetingModel: MeetingModel, completion: @escaping (Bool) -> Void) {
        guard let meetingViewController = STORYBOARD.HOME.instantiateViewController(withIdentifier: "meeting")
            as? MeetingViewController, let rootViewController = self.rootViewController else {
            completion(false)
            return
        }
        meetingViewController.modalPresentationStyle = .fullScreen
        meetingViewController.meetingModel = meetingModel
        rootViewController.present(meetingViewController, animated: true) {
            self.activeMeetingViewController = meetingViewController
            completion(true)
        }
    }

    func dismissActiveMeetingView(completion: @escaping () -> Void) {
        guard let activeMeetingViewController = activeMeetingViewController else {
            completion()
            return
        }
        activeMeetingViewController.dismiss(animated: true) {
            self.activeMeetingViewController = nil
            if AppModel.shared.currentUser.user?.userType == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.ADD_RATEREVIEW_DATA), object: nil)
            }
            completion()
        }
    }
}
