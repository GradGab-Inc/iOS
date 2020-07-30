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
    
    var arr = [SIDEMENU_DATA.PROFILE, SIDEMENU_DATA.NOTI, SIDEMENU_DATA.MY_ERNING, SIDEMENU_DATA.BANK, SIDEMENU_DATA.REFER, SIDEMENU_DATA.SETTING]
    var img = ["ic_profile_hm","ic_notifications","ic_myearnings_hm","ic_bankdetails_hm","ic_profile_hm","ic_settings_hm"]
    
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
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : SideMenuTVC = sidemenuTbl.dequeueReusableCell(withIdentifier: "SideMenuTVC", for: indexPath) as! SideMenuTVC
        cell.lbl.text = arr[indexPath.row]
        cell.imgView.image = UIImage.init(named: img[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.menuContainerViewController.toggleLeftSideMenuCompletion(nil)
        if indexPath.row == 0
        {
            
        }
        else if indexPath.row == 1
        {
            
        }
        else if indexPath.row == 2
        {
            
        }
        else if indexPath.row == 3
        {
            
        }
    }
}
