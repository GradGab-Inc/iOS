//
//  AboutUsVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class AboutUsVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var aboutTxtView: UITextView!
    
    var type : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if type == 0 {
            navigationBar.headerLbl.text = "About Us"
        }
        else if type == 1 {
            navigationBar.headerLbl.text = "Terms & Conditions"
        }
        else if type == 2 {
            navigationBar.headerLbl.text = "Privacy Policy"
        }
        
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataSetUp), name: NSNotification.Name.init(NOTIFICATION.GET_ABOUT_DATA), object: nil)
        
        aboutTxtView.delegate = self
        
        if AppModel.shared.aboutUsData.aboutUs == "" || AppModel.shared.aboutUsData.privacyPolicy == "" || AppModel.shared.aboutUsData.termsAndCondition == "" {
            AppDelegate().sharedDelegate().getAboutUsData()
        }
        else {
            dataSetUp()
        }
    }
    
    @objc func dataSetUp()  {
        if type == 0 {
            aboutTxtView.text = AppModel.shared.aboutUsData.aboutUs.html2String
        }
        else if type == 1 {
            aboutTxtView.text = AppModel.shared.aboutUsData.termsAndCondition.html2String
        }
        else if type == 2 {
            aboutTxtView.text = AppModel.shared.aboutUsData.privacyPolicy.html2String
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        log.success("AboutUsVC Memory deallocated!")/
    }
}
