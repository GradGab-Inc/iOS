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
    @IBOutlet weak var viewAllBtn: UIButton!
    
    @IBOutlet var completeProfileBackView: UIView!
    @IBOutlet var joinCallBackView: UIView!
    @IBOutlet weak var profileImgBtn: UIButton!
    
    var titleArr = ["Chat","Virtual Tour","Interview Prep"]
    var subTitleArr = ["Video chat with a current student.","Get a live 1 hour campus tour.","45 Min Mock Interview Prep or Mock interview."]
    let backImgArr = ["Image_Chat","Image_Virtual_Tour","Image_Interview Prep"]
    
    var bookingListVM : HomeBookingListViewModel = HomeBookingListViewModel()
    var bookingArr : [BookingListDataModel] = [BookingListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
//        var dict : [String : Any] = [String : Any]()
//        dict["name"] = "Vishal1234"
//        dict["date"] = "2020-10-21T05:15:00.000Z"
//        let JoinCallVC : JoinCallView = JoinCallView.instanceFromNib() as! JoinCallView
//        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: JoinCallVC)
//        JoinCallVC.dict = dict as! [String : Any]
//        JoinCallVC.setUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppModel.shared.currentUser.user?.userType == 3 || AppModel.shared.currentUser.user?.profileCompleted == false {
            completeProfileBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: completeProfileBackView)
            viewAllBtn.isHidden = true
        }
        else {
            completeProfileBackView.isHidden = true
        }
        
        if AppModel.shared.currentUser.user != nil {
            setUserImageOnButton(profileImgBtn, API.IMAGE_URL + AppModel.shared.currentUser.user!.image)
            self.profileImgBtn.imageView?.contentMode = .scaleAspectFill
            
            nameLbl.text = "\(AppModel.shared.currentUser.user?.firstName ?? "")"
        }
    }
        
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookingList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(redirectToNotification), name: NSNotification.Name.init(NOTIFICATION.REDICT_TO_NOTIFICATION), object: nil)
        
        homeTblView.register(UINib.init(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        viewAllBtn.isHidden = true
        
        bookingTblView.reloadData()
        bookingTblViewHeightConstraint.constant = 160
        
        bookingListVM.delegate = self
        refreshBookingList()
        
        joinCallBackView.isHidden = true
        
        self.view.sainiAddSwipe { (data) in
            if data == Swipe.down {
                self.refreshBookingList()
            }
        }
    }
    
    @objc func refreshBookingList() {
        bookingListVM.getBookingList(request: BookingListRequest(limit : 2))
    }
    
    @objc func redirectToNotification() {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
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

extension HomeVC : HomeBookingListDelegate {
    func didRecieveHomeBookingListResponse(response: BookingListModel) {
        bookingArr = [BookingListDataModel]()
        bookingArr = response.data
        bookingTblView.reloadData()
        
        noDataLbl.isHidden = bookingArr.count == 0 ? false : true
        viewAllBtn.isHidden = bookingArr.count == 0 ? true : false
        
        if bookingArr.count == 0 {
            bookingTblViewHeightConstraint.constant = 160
        }
    }
 }

//MARK: - TableView Delegate
extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeTblView {
            return 3
        }
        else {
            return bookingArr.count
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
        else {
            guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
                else {
                return UITableViewCell()
            }
            
            let dict : BookingListDataModel = bookingArr[indexPath.row]
            cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
            
            let name = dict.name.components(separatedBy: " ")
            cell.nameLbl.text = "\(dict.firstName) \(dict.lastName != "" ? "\(dict.lastName.first!.uppercased())." : "")"
//            cell.nameLbl.text = "\(name[0]) \(name.count == 2 ? "\(name[1].first!.uppercased())." : "")"
            
            cell.collegeNameLbl.text = dict.schoolName
            cell.timeLbl.text = displayBookingDate(dict.dateTime, callTime: dict.callTime)
            
            cell.joinBtn.isHidden = true
            cell.bookedBtn.isHidden = false
            cell.bookedBtn.setTitle(getbookingType(dict.status), for: .normal)
            cell.bookedBtn.setTitleColor(getbookingColor(dict.status), for: .normal)
            
            bookingTblViewHeightConstraint.constant = bookingArr.count == 1 ? 126 : 252
            return cell
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == homeTblView {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
            vc.isMenteeUser = true
            if indexPath.row == 0 {
                vc.selectedType = 1
            }
            else if indexPath.row == 1 {
                vc.selectedType = 3
            }
            else if indexPath.row == 2 {
                vc.selectedType = 2
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            vc.selectedBooking = bookingArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func clickToJoinCall(_ sender : UIButton) {

    }
    
}
