//
//  CalenderDateListVC.swift
//  Gradgap
//
//  Created by iMac on 12/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class CalenderDateListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var updateBtn: Button!
    @IBOutlet weak var setBtn: Button!
    
    var dateListVM : AvailabilityListViewModel = AvailabilityListViewModel()
    var availabilityListArr : [AvailabilityDataModel] = [AvailabilityDataModel]()
    
    var bookingListVM : HomeBookingListViewModel = HomeBookingListViewModel()
    var bookingArr : [BookingListDataModel] = [BookingListDataModel]()
    var selectedDate : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = getDateStringFromDate(date: selectedDate, format: "EE, MMMM dd, yyyy")
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "CalenderListTVC", bundle: nil), forCellReuseIdentifier: "CalenderListTVC")
        
        dateListVM.delegate = self
        dateListVM.availabilityList()
        
        bookingListVM.delegate = self
        refreshBookingList()
    }
    
    @objc func refreshBookingList() {
        let endDate = getDateStringFromDate(date: self.selectedDate, format: "yyyy-MM-dd")
        
        let maxDate : Date = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        let startDate = getDateStringFromDate(date: maxDate, format: "yyyy-MM-dd")
        
        bookingListVM.getBookingList(request: BookingListRequest(status: 1, dateStart: "\(startDate) 6:30:00", dateEnd: "\(endDate) 18:30:00"))
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToUpdateAvailabilityBack(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "UpdateAvailabilityVC") as! UpdateAvailabilityVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSetAvailabilityBack(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SetAvailabilityVC") as! SetAvailabilityVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    deinit {
        log.success("CalenderDateListVC Memory deallocated!")/
    }
    
}

extension CalenderDateListVC : AvailabilityListDelegate {
    func didRecieveAvailabilityListResponse(response: AvailabiltyListModel) {
        availabilityListArr = [AvailabilityDataModel]()
        availabilityListArr = response.data
        tblView.reloadData()
        updateBtn.isHidden = availabilityListArr.count == 0 ? true : false
    }
}

extension CalenderDateListVC : HomeBookingListDelegate {
   func didRecieveHomeBookingListResponse(response: BookingListModel) {
        bookingArr = [BookingListDataModel]()
        bookingArr = response.data
        tblView.reloadData()
   }
}

//MARK: - TableView Delegate
extension CalenderDateListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingArr.count//timeSloteArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CalenderListTVC", for: indexPath) as? CalenderListTVC
            else {
            return UITableViewCell()
        }
        
        let dict : BookingListDataModel = bookingArr[indexPath.row]
        let time1 = getDateStringFromDateString(strDate: dict.dateTime, formate: "hh a")
        let date2 = getDateFromDateString(strDate: dict.dateTime).sainiAddMinutes(Double(dict.callTime))
        let time2 = getDateStringFromDate(date: date2, format: "hh a")
        
        cell.timeLbl.text = "\(time1) - \(time2)"
        cell.eventLbl.text = "Meeting with \(dict.name) \(getbookingType(dict.status))"

        
//        if indexPath.row == 1 || indexPath.row == 7 {
//            cell.backView.isHidden = false
//        }
//        else {
//            cell.backView.isHidden = true
//        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
       vc.selectedBooking = bookingArr[indexPath.row]
       self.navigationController?.pushViewController(vc, animated: true)
    }
        
}
