//
//  MentorHomeVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import FSCalendar
import SainiUtils

class MentorHomeVC: UIViewController {

    @IBOutlet weak var bookingTblView: UITableView!
    @IBOutlet weak var bookingTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var homeCalender: FSCalendar!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var topHeaderDateLbl: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet var completeProfileBackView: UIView!
    @IBOutlet var timeBackView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    
    
    var bookingListVM : HomeBookingListViewModel = HomeBookingListViewModel()
    var bookingActionVM : BookingActionViewModel = BookingActionViewModel()
    var bookingArr : [BookingListDataModel] = [BookingListDataModel]()
    var selectedDate : Date = Date()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    private var currentPage: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppModel.shared.currentUser.user?.userType == 3 {
            completeProfileBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: completeProfileBackView)
            messageLbl.isHidden = false
        }
        else {
            completeProfileBackView.isHidden = true
        }
        homeCalender.reloadData()
    }
        
    //MARK: - configUI
    func configUI() {
        timeBackView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookingList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTOR_HOME_DATA), object: nil)
        
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        viewAllBtn.isHidden = true
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 16.0), NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 16.0), NSAttributedString.Key.foregroundColor : UIColor.red]
        
        let attributedString1 = NSMutableAttributedString(string: "You don’t have any bookings yet, ", attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string:"Refer ", attributes: attrs2)
        let attributedString3 = NSMutableAttributedString(string: "some friends.", attributes: attrs1)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        noDataLbl.attributedText = attributedString1
        
        bookingTblView.reloadData()
        bookingTblViewHeightConstraint.constant = 200
        
        bookingListVM.delegate = self
        bookingActionVM.delegate = self
        refreshBookingList()
        
        headerLbl.text = getDateStringFromDate(date: homeCalender.currentPage, format: "MMMM yyyy")
        topHeaderDateLbl.text = getDateStringFromDate(date: homeCalender.currentPage, format: "MMMM dd/MM/yyyy")
    }
    
    @objc func refreshBookingList() {
        bookingListVM.getBookingList(request: BookingListRequest(limit : 2))
    }
    
    //MARK: - Button Click
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion({ })
    }
    
    @IBAction func clickToViewAll(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingListVC") as! BookingListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToNextMonth(_ sender: Any) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: homeCalender.currentPage)
        homeCalender.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func clickToPreviousMonth(_ sender: Any) {
      let nextMonth = Calendar.current.date(byAdding: .month, value: -1, to: homeCalender.currentPage)
      homeCalender.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func clickToCompleteProfile(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "StudentEnrollVC") as! StudentEnrollVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.success("MentorHomeVC Memory deallocated!")/
    }
    
}

extension MentorHomeVC : HomeBookingListDelegate {
   func didRecieveHomeBookingListResponse(response: BookingListModel) {
        bookingArr = [BookingListDataModel]()
        bookingArr = response.data
        bookingTblView.reloadData()
    
        noDataLbl.isHidden = bookingArr.count == 0 ? false : true
        viewAllBtn.isHidden = bookingArr.count == 0 ? true : false
        if bookingArr.count == 0 {
            bookingTblViewHeightConstraint.constant = 200
        }
        messageLbl.isHidden = bookingArr.count == 0 ? false : true
    
        homeCalender.layoutIfNeeded()
        homeCalender.setNeedsLayout()
   }
}

extension MentorHomeVC : BookingActionDelegate {
    func didRecieveBookingActionResponse(response: SuccessModel) {
        displayToast(response.message)
        refreshBookingList()
    }
}


//MARK: - TableView Delegate
extension MentorHomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
            else {
            return UITableViewCell()
        }
        
        let dict : BookingListDataModel = bookingArr[indexPath.row]
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
        
        let name = dict.name.components(separatedBy: " ")
        cell.nameLbl.text = "\(name[0]) \(name.count == 2 ? "\(name[1].first!.uppercased())." : "")"
        
        cell.collegeNameLbl.text = " \(getCallType(dict.callType)) \(dict.callTime) Minutes "
        
        cell.labelBackView.backgroundColor = AppColor
        cell.collegeNameLbl.textColor = WhiteColor
        cell.collegeNameLbl.font = UIFont(name: "MADETommySoft", size: 13.0)
        
        cell.timeLbl.text = displayBookingDate(dict.dateTime, callTime: dict.callTime)
        cell.joinBtn.isHidden = true
        cell.joinBtn.tag = indexPath.row
        
        cell.bookedBtn.isHidden = true
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
            cell.bookedBtn.isUserInteractionEnabled = false
        }
        bookingTblViewHeightConstraint.constant = bookingArr.count == 1 ? 126 : 252
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorBookingDetailVC") as! MentorBookingDetailVC
        vc.selectedBooking = bookingArr[indexPath.row]
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToJoinCall(_ sender : UIButton) {
        let dict : BookingListDataModel = bookingArr[sender.tag]
        let request = GetBookingActionRequest(bookingRef: dict.id, status: BookingStatus.BOOKED)
        bookingActionVM.getBookingAction(request: request)
    }
}

extension MentorHomeVC : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        topHeaderDateLbl.text = getDateStringFromDate(date: date, format: "MMMM dd/MM/yyyy")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "CalenderDateListVC") as! CalenderDateListVC
//        vc.selectedDate = date
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SelectAvaibilityVC") as! SelectAvaibilityVC
        vc.selectedDate = date
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
        headerLbl.text = getDateStringFromDate(date: calendar.currentPage, format: "MMMM yyyy")
    }
}
