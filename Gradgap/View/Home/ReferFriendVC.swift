//
//  ReferFriendVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import Branch

class ReferFriendVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Refer Friends"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        if AppModel.shared.currentUser.user?.userType == 1 {
            messageLbl.text = "Get 25% off for every referred friend that books a chat!"
        }
        else {
            messageLbl.text = "Refer friends and they will get 25% off their first chat!"
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToRefer(_ sender: Any) {
         generateLink()        
    }
    
    func generateLink() {
        let title = "GradGab"
        
        var desc : String = String()
        if AppModel.shared.currentUser.user?.userType == 1 {
            desc = "Hey I'm using GradGab to chat with current students at schools I'm exploring, download the app here and check it out!"
        }
        else {
            desc = "Hey I'm using GradGab to chat with current students at schools I'm exploring, download the app here and check it out and get 25% off your first chat!"
        }
//        let imgURL = "https://shiftbookd.com/img/shiftbookd-app.png"

        let buo = BranchUniversalObject()
        buo.canonicalIdentifier = "content/12345"
        buo.title = title
        buo.contentDescription = desc
//        buo.imageUrl = imgURL
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.contentSchema = BranchContentSchema.commerceProduct
        buo.contentMetadata.customMetadata["deepLinkPayload"] = AppModel.shared.currentUser.user.toJSON()

        let lp = BranchLinkProperties.init()
        lp.addControlParam("timeStamp", withValue: getCurrentTimeStampValue())
        buo.getShortUrl(with: lp) { (url, error) in
            if error == nil {
                var strUrl : String = String()
                if AppModel.shared.currentUser.user?.userType == 1 {
                    strUrl = "Hey I'm using GradGab to chat with current students at schools I'm exploring, download the app here and check it out! " + url!
                }
                else {
                    strUrl = "Hey I'm using GradGab to chat with current students at schools I'm exploring, download the app here and check it out and get 25% off your first chat! " + url!
                }
                
                let activityViewController = UIActivityViewController(activityItems: [strUrl] , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        log.success("ReferFriendVC Memory deallocated!")/
    }
    
}
