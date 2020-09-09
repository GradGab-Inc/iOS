//
//  SettingVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class SettingVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var switchBtn: UIButton!
    
    var settingArr = [SETTING_ARR.ABOUT, SETTING_ARR.TERMS, SETTING_ARR.PRIVACY, SETTING_ARR.HELP, SETTING_ARR.LOGOUT]
    var imgArr = ["ic_aboutus","ic_terms","ic_privacypolicy","ic_help","ic_logout"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Settings"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "SideMenuTVC", bundle: nil), forCellReuseIdentifier: "SideMenuTVC")
        
        if AppModel.shared.currentUser.user?.userType == 1 {
            switchBtn.setTitle("Swith to Mentor App", for: .normal)
        }
        else {
            switchBtn.setTitle("Swith to Mentee App", for: .normal)
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToswithToMentorApp(_ sender: Any) {
        
    }
    
    deinit {
        log.success("SettingVC Memory deallocated!")/
    }
}


//MARK: - TableView Delegate
extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as? SideMenuTVC
            else {
            return UITableViewCell()
        }
        
        cell.lbl.text = settingArr[indexPath.row]
        cell.imgView.image = UIImage.init(named: imgArr[indexPath.row])
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.type = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.type = 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            vc.type = 2
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            showAlertWithOption("Confirmation", message: "Are you sure you want to logout?", btns: ["Cancel","Ok"], completionConfirm: {
                
                AppDelegate().sharedDelegate().continueToLogout()
                
            }) {
                
            }
        }
    }
}
