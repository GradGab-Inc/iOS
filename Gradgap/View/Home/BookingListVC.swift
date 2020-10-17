//
//  BookingListVC.swift
//  Gradgap
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class BookingListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var bookingTblView: UITableView!
    
    @IBOutlet var filterBackView: UIView!
    @IBOutlet weak var filterTblView: UITableView!
    @IBOutlet weak var filterTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var mentorArr = ["Confirmed","Unconfirmed"]
    var menteeArr = ["Booked","Cancelled","Pending","Rejected"]
    var filterArr : [String] = [String]()
    
    private var filterSelectIndex = 0
    var selectedDate = Date()
    var selectedStartDate = Date()
    var selectedEndDate = Date()
//    let JoinCallVC : JoinCallView = JoinCallView.instanceFromNib() as! JoinCallView
    var currentPage : Int = 1
    
    var dataModel : BookingListModel = BookingListModel()
    var bookingListVM : HomeBookingListViewModel = HomeBookingListViewModel()
    var bookingActionVM : BookingActionViewModel = BookingActionViewModel()
    var bookingArr : [BookingListDataModel] = [BookingListDataModel]()
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var isMentor : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Bookings"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.addTarget(self, action: #selector(self.clickToFilter), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDataSetUp), name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTOR_HOME_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDataSetUp), name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
        
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        filterTblView.register(UINib(nibName: "FilterTVC", bundle: nil), forCellReuseIdentifier: "FilterTVC")
        if AppModel.shared.currentUser.user?.userType == 1 {
            filterArr = menteeArr
        }
        else {
            filterArr = mentorArr
        }
        
        filterBackView.isHidden = true
        self.fromDateLbl.text = getDateStringFromDate(date: selectedStartDate, format: "MM/dd/YYYY")
        selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedStartDate) ?? Date()
        self.toDateLbl.text = getDateStringFromDate(date: selectedEndDate, format: "MM/dd/YYYY")
        
        bookingListVM.delegate = self
        bookingActionVM.delegate = self
        bookingListVM.getBookingList(request: BookingListRequest(page: currentPage))
        
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        bookingTblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
    @objc func refreshDataSetUp() {
        refreshControl.endRefreshing()
        currentPage = 1
        bookingListVM.getBookingList(request: BookingListRequest(page: currentPage))
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFilter(_ sender: Any) {
        filterBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: filterBackView)
    }
    
    @IBAction func clickToApply(_ sender: Any) {
        var request : BookingListRequest = BookingListRequest()
                
        request.dateStart = getDateInUTC(selectedStartDate)
        let endDate : Date = Calendar.current.date(byAdding: .day, value: 1, to: selectedEndDate)!
        request.dateEnd = getDateInUTC(endDate)
        
        let index = filterSelectIndex + 1
        if isMentor {
            request.status = index == 2 ? 3 : index
        }
        else {
            request.status = index
        }
        bookingListVM.getBookingList(request: request)
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToFromDate(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Date", selected: selectedStartDate, min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedStartDate = date!
               
                self.fromDateLbl.text = getDateStringFromDate(date: self.selectedStartDate, format: "MM/dd/YYYY")
                
                self.selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedStartDate) ?? Date()
                self.toDateLbl.text = getDateStringFromDate(date: self.selectedEndDate, format: "MM/dd/YYYY")
            }
        }
    }
    
    @IBAction func clickToToDate(_ sender: Any) {
        self.view.endEditing(true)
        let maxDate : Date = Calendar.current.date(byAdding: .day, value: 1, to: selectedStartDate)!
        DatePickerManager.shared.showPicker(title: "Select Date", selected: selectedEndDate, min: maxDate, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedEndDate = date!
            
                self.toDateLbl.text = getDateStringFromDate(date: self.selectedEndDate, format: "MM/dd/YYYY")
            }
        }
    }
    
    deinit {
        log.success("BookingListVC Memory deallocated!")/
    }
    
}

extension BookingListVC : HomeBookingListDelegate {
   func didRecieveHomeBookingListResponse(response: BookingListModel) {
        dataModel = response
        if currentPage == 1 {
            bookingArr = [BookingListDataModel]()
        }
        for item in response.data {
            bookingArr.append(item)
        }
        bookingTblView.reloadData()
        noDataLbl.isHidden = bookingArr.count == 0 ? false : true
   }
}

extension BookingListVC : BookingActionDelegate {
    func didRecieveBookingActionResponse(response: SuccessModel) {
        displayToast(response.message)
        refreshDataSetUp()
    }
}


//MARK: - TableView Delegate
extension BookingListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bookingTblView {
            return bookingArr.count
        }
        else {
            return filterArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == bookingTblView {
            return 126
        }
        else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bookingTblView {
            guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
                else {
                return UITableViewCell()
            }
            
            let dict : BookingListDataModel = bookingArr[indexPath.row]
            cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
            
            let name = dict.name.components(separatedBy: " ")
            cell.nameLbl.text = "\(dict.firstName) \(dict.lastName != "" ? "\(dict.lastName.first!.uppercased())." : "")"
//            cell.nameLbl.text = "\(name[0]) \(name.count == 2 ? "\(name[1].first!.uppercased())." : "")"
            
            cell.timeLbl.text = displayBookingDate(dict.dateTime, callTime: dict.callTime)
            
            if AppModel.shared.currentUser.user?.userType == 1 {
                cell.collegeNameLbl.text = dict.schoolName
                cell.joinBtn.isHidden = true
                cell.bookedBtn.isHidden = false
                cell.bookedBtn.setTitle(getbookingType(dict.status), for: .normal)
                cell.bookedBtn.setTitleColor(getbookingColor(dict.status), for: .normal)
            }
            else {
                cell.joinBtn.isHidden = true
                cell.bookedBtn.isHidden = true
                cell.joinBtn.tag = indexPath.row
                cell.collegeNameLbl.text = " \(getCallType(dict.callType)) \(dict.callTime) Minutes "
                
                cell.labelBackView.backgroundColor = AppColor
                cell.collegeNameLbl.textColor = WhiteColor
                cell.collegeNameLbl.font = UIFont(name: "MADETommySoft", size: 13.0)
                
                if dict.status == 3 {
                    cell.joinBtn.isHidden = false
                    cell.joinBtn.setImage(UIImage.init(named: ""), for: .normal)
                    cell.joinBtn.setTitle("Confirm", for: .normal)
                    cell.joinBtn.isUserInteractionEnabled = true
                    cell.joinBtn.addTarget(self, action: #selector(self.clickToJoinCall), for: .touchUpInside)
                }
                else {
                    cell.bookedBtn.isHidden = false
                    cell.bookedBtn.setTitle(getbookingType(dict.status), for: .normal)
                    cell.bookedBtn.setTitleColor(getbookingColor(dict.status), for: .normal)
                }
            }
            
            return cell
        }
        else {
            guard let cell = filterTblView.dequeueReusableCell(withIdentifier: "FilterTVC", for: indexPath) as? FilterTVC
                else {
                return UITableViewCell()
            }
            cell.titleLbl.text = filterArr[indexPath.row]
            
            cell.selectBtn.tag = indexPath.row
            cell.selectBtn.addTarget(self, action: #selector(self.clickToSelectFilter), for: .touchUpInside)
            if filterSelectIndex == indexPath.row {
                cell.selectBtn.isSelected = true
            }
            else {
                cell.selectBtn.isSelected = false
            }
            
            filterTblViewHeightConstraint.constant = filterTblView.contentSize.height
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == bookingTblView {
            print(indexPath.row)
            if bookingArr.count - 2 == indexPath.row {
                if dataModel.hasMore {
                    currentPage = currentPage + 1
                    bookingListVM.getBookingList(request: BookingListRequest(page: currentPage))
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppModel.shared.currentUser.user?.userType == 1 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
            vc.selectedBooking = bookingArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorBookingDetailVC") as! MentorBookingDetailVC
             vc.selectedBooking = bookingArr[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
    @objc func clickToSelectFilter(_ sender : UIButton) {
        filterSelectIndex = sender.tag
        filterTblView.reloadData()
    }
    
    @objc func clickToJoinCall(_ sender : UIButton) {
        if AppModel.shared.currentUser.user?.userType == 1 {
//            displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: JoinCallVC)
//            JoinCallVC.setUp(0)
        }
        else  {
            let dict : BookingListDataModel = bookingArr[sender.tag]
            let request = GetBookingActionRequest(bookingRef: dict.id, status: BookingStatus.BOOKED)
            bookingActionVM.getBookingAction(request: request)
        }
    }
    
}
