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
    var timeSlots = [Double]()
    var arrSkipIndex = [Int]()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDateList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTOR_BOOKED_DATA), object: nil)
        
        tblView.register(UINib(nibName: "CalenderListTVC", bundle: nil), forCellReuseIdentifier: "CalenderListTVC")
        
        dateListVM.delegate = self
        refreshDateList()
        
        bookingListVM.delegate = self
        refreshBookingList()
            
    }
    
    @objc func refreshBookingList() {        
        let endDate : Date = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        var request : BookingListRequest = BookingListRequest()
        request.dateStart = getDateInUTC(selectedDate)
        request.dateEnd = getDateInUTC(endDate)
        request.status = 1
        
        bookingListVM.getBookingList(request: request)
        
    }
    
    @objc func refreshDateList()  {
        dateListVM.availabilityList()
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
        setupTimeData()
        tblView.reloadData()
   }
    
    
    //hide time cell if slot already booked
    func setupTimeData()
    {
        arrSkipIndex = [Int]()
        for i in 0..<timeSloteArr.count {
            let tempTime = timeSloteArr[i]
            let index = bookingArr.firstIndex { (temp) -> Bool in
                getDateStringFromDateString(strDate: temp.dateTime, formate: "hh:mm a") == tempTime
            }
            if index != nil {
                let duration = bookingArr[index!].callTime
                if let startDate : Date = getDateFromDateString(strDate: "01-01-2001 " + timeSloteArr[i], format: "dd-MM-yyyy hh:mm a") {
                    let endDate = Calendar.current.date(byAdding: .minute, value: duration, to: startDate)!
                    let endTime = getDateStringFromDate1(date: endDate, format: "hh:mm a")
                    arrSkipIndex.append(i)
                    for j in i..<timeSloteArr.count {
                        if (j+1) != timeSloteArr.count {
                            if endTime == timeSloteArr[j+1] {
                                break
                            }
                            arrSkipIndex.append(j+1)
                        }
                    }
                }
            }
        }
    }
}

//MARK: - TableView Delegate
extension CalenderDateListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSloteArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CalenderListTVC", for: indexPath) as? CalenderListTVC
            else {
            return UITableViewCell()
        }
        
 //       let dict : BookingListDataModel = bookingArr[indexPath.row]
//        let time1 = getDateStringFromDateString(strDate: dict.dateTime, formate: "hh:mm a")
//        let date2 = getDateFromDateString(strDate: dict.dateTime).sainiAddMinutes(Double(dict.callTime))
//        let time2 = getDateStringFromDate(date: date2, format: "hh:mm a")
        
        cell.eventLbl.text = ""
        cell.timeLbl.text = timeSloteArr[indexPath.row]//"\(time1) - \(time2)"

        if arrSkipIndex.contains(indexPath.row) {
            cell.backView.isHidden = false
        }else{
            cell.backView.isHidden = true
        }
        
        let index = bookingArr.firstIndex { (temp) -> Bool in
            getDateStringFromDateString(strDate: temp.dateTime, formate: "hh:mm a") == timeSloteArr[indexPath.row]
        }
        if index != nil {
            let dict = bookingArr[index!]
            cell.eventLbl.text = "Meeting with \(dict.name) \(getbookingType(dict.status))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = bookingArr.firstIndex { (temp) -> Bool in
//            getDateStringFromDateString(strDate: temp.dateTime, formate: "hh:mm a") == timeSloteArr[indexPath.row]
//        }
//        if index != nil {
//            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "MentorBookingDetailVC") as! MentorBookingDetailVC
//            vc.selectedBooking = bookingArr[index!]
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
        
}
