//
//  NotificationVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class NotificationVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var dataModel : NotificationResponse = NotificationResponse()
    var notificationListVM : NotificationViewModel = NotificationViewModel()
    var notificationArr : [NotificationListModel] = [NotificationListModel]()
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var currentPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Notifications"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "NotificationTVC", bundle: nil), forCellReuseIdentifier: "NotificationTVC")
        
        notificationListVM.delegate = self
        notificationListVM.notificationList(request: MorePageRequest(page: currentPage))
        
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
     @objc func refreshDataSetUp() {
         refreshControl.endRefreshing()
         currentPage = 1
         notificationListVM.notificationList(request: MorePageRequest(page: currentPage))
     }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        log.success("NotificationVC Memory deallocated!")/
    }
}

extension NotificationVC : NotificationDelegate {
    func didRecieveNotificationListResponse(response: NotificationResponse) {
        dataModel = response
        if currentPage == 1 {
            notificationArr = [NotificationListModel]()
        }
        for item in response.data {
            notificationArr.append(item)
        }
        tblView.reloadData()
        noDataLbl.isHidden = notificationArr.count == 0 ? false : true
    }
}

//MARK: - TableView Delegate
extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as? NotificationTVC
            else {
            return UITableViewCell()
        }
        
        let dict : NotificationListModel = notificationArr[indexPath.row]
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
        cell.messagelbl.text = "\(dict.firstName) \(dict.lastName != "" ? "\(dict.lastName.first!.uppercased())." : "") \(dict.message)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if notificationArr.count - 2 == indexPath.row {
            if dataModel.hasMore {
                currentPage = currentPage + 1
                notificationListVM.notificationList(request: MorePageRequest(page: currentPage))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedNotification : BookingListDataModel = BookingListDataModel.init()
        selectedNotification.id = notificationArr[indexPath.row].ref
        if AppModel.shared.currentUser.user?.userType == 1 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            vc.selectedBooking = selectedNotification
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if AppModel.shared.currentUser.user?.userType == 2 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorBookingDetailVC") as! MentorBookingDetailVC
             vc.selectedBooking = selectedNotification
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }    
}
