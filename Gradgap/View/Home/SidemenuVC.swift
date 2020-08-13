//
//  SidemenuVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import MFSideMenu

class SidemenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var sidemenuTbl: UITableView!
    
    var isMentor : Bool = true
    
    var arr = [SIDEMENU_DATA.PROFILE, SIDEMENU_DATA.NOTI, SIDEMENU_DATA.BOOKING, SIDEMENU_DATA.FAVORITE, SIDEMENU_DATA.TRANSACTION,SIDEMENU_DATA.PAY_METHODE, SIDEMENU_DATA.REFER_FRIEND, SIDEMENU_DATA.SETTING]
    var img = ["ic_profile_hm", "ic_notifications", "ic_bookings_hm", "ic_favorites_hm", "ic_myearnings_hm", "ic_paymentmethod_hm", "ic_refer_hm", "ic_settings_hm"]
    
    var mentorArr = [MENTOR_SIDEMENU_DATA.PROFILE, MENTOR_SIDEMENU_DATA.NOTI, MENTOR_SIDEMENU_DATA.MY_EARN, MENTOR_SIDEMENU_DATA.BANK_DETAIL, MENTOR_SIDEMENU_DATA.REFER_FRIEND, MENTOR_SIDEMENU_DATA.SETTING]
    var mentorImg = ["ic_profile_hm", "ic_notifications", "ic_myearnings_hm", "ic_bankdetails_hm", "ic_refer_hm", "ic_settings_hm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sidemenuTbl.register(UINib(nibName: "SideMenuTVC", bundle: nil), forCellReuseIdentifier: "SideMenuTVC")
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToClose(_ sender: Any) {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
    }
    
    
    //MARK: - Table View    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isMentor ? mentorArr.count : arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : SideMenuTVC = sidemenuTbl.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        cell.lbl.text = isMentor ? mentorArr[indexPath.row] : arr[indexPath.row]
        cell.imgView.image = UIImage.init(named: isMentor ? mentorImg[indexPath.row] : img[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        if indexPath.row == 0
        {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1
        {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2
        {
            if isMentor {
                
            }
            else {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingListVC") as! BookingListVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.row == 3
        {
            if isMentor {
                
            }
            else {
                let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FavoriteVC") as! FavoriteVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
