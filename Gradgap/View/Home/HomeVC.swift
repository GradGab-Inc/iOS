//
//  HomeVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class HomeVC: UIViewController {

    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var bookingTblView: UITableView!
    @IBOutlet weak var bookingTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet var completeProfileBackView: UIView!
    @IBOutlet var joinCallBackView: UIView!
    
    
    var titleArr = ["Chat","Virtual Tour","Interview Prep"]
    var subTitleArr = ["Video chat with a current student.","Get a live 1 hour campus tour.","45 Min Mock Interview Prep or Mock interview."]
    let JoinCallVC : JoinCallView = JoinCallView.instanceFromNib() as! JoinCallView
    let backImgArr = ["Image_Chat","Image_Virtual_Tour","Image_Interview Prep"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppModel.shared.currentUser.user?.userType == 3 {
            completeProfileBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: completeProfileBackView)
        }
    }
    
    //MARK: - configUI
    func configUI() {
        homeTblView.register(UINib.init(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        noDataLbl.isHidden = true
        
        bookingTblView.reloadData()
        bookingTblViewHeightConstraint.constant = 234
        
        joinCallBackView.isHidden = true
    }
    
    //MARK: - Button Click
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion({ })
    }
    
    @IBAction func clickToProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToViewAll(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingListVC") as! BookingListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCompleteProfile(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToJoinNowCall(_ sender: Any) {
        joinCallBackView.isHidden = true
    }
    
    deinit {
        log.success("HomeVC Memory deallocated!")/
    }
    
}

//MARK: - TableView Delegate
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeTblView {
            return 3
        }
        else{
           return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == homeTblView {
            return 120
        }
        else {
           return 126
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == homeTblView {
            guard let cell = homeTblView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC
                else {
                return UITableViewCell()
            }
            cell.titleLbl.text = titleArr[indexPath.row]
            cell.subLbl.text = subTitleArr[indexPath.row]
            cell.backImg.image = UIImage.init(named: backImgArr[indexPath.row])
            
            return cell
        }
        else{
            guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
                else {
                return UITableViewCell()
            }
            cell.bookedBtn.isHidden = true
            cell.joinBtn.isHidden = true
            if indexPath.row == 0 {
                cell.joinBtn.isHidden = false
                cell.joinBtn.tag = indexPath.row
                cell.joinBtn.addTarget(self, action: #selector(self.clickToJoinCall), for: .touchUpInside)
            }
            else {
                cell.bookedBtn.isHidden = false
            }

           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == homeTblView {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookChatVC") as! BookChatVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
           let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func clickToJoinCall(_ sender : UIButton) {
        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: JoinCallVC)
        JoinCallVC.setUp(0)
    }
    
}
