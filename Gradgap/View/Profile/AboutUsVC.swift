//
//  AboutUsVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class AboutUsVC: UIViewController {

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
        
        if AppModel.shared.aboutUsData.aboutUs == "" {
            AppDelegate().sharedDelegate().getAboutUsData()
        }
        else {
            dataSetUp()
        }
    }
    
    @objc func dataSetUp()  {
        if type == 0 {
            aboutTxtView.text = AppModel.shared.aboutUsData.aboutUs
        }
        else if type == 1 {
            aboutTxtView.text = AppModel.shared.aboutUsData.termsAndCondition
        }
        else if type == 2 {
            aboutTxtView.text = AppModel.shared.aboutUsData.privacyPolicy
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    deinit {
        log.success("AboutUsVC Memory deallocated!")/
    }
}
