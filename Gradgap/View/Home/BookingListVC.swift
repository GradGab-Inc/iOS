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
    
    var filterArr = ["Booked","Completed","Cancelled"]
    private var filterSelectArr = [Int]()
    var selectedDate : Date!
    var selectedStartDate : Date!
    var selectedEndDate : Date!
    let JoinCallVC : JoinCallView = JoinCallView.instanceFromNib() as! JoinCallView
    
    
    var bookingListVM : HomeBookingListViewModel = HomeBookingListViewModel()
    var bookingArr : [BookingListDataModel] = [BookingListDataModel]()
    
    
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
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        filterTblView.register(UINib(nibName: "FilterTVC", bundle: nil), forCellReuseIdentifier: "FilterTVC")
        filterBackView.isHidden = true
        self.fromDateLbl.text = getDateStringFromDate(date: Date(), format: "MM/dd/YYYY")
        self.toDateLbl.text = getDateStringFromDate(date: Date(), format: "MM/dd/YYYY")
        
        bookingListVM.delegate = self
        bookingListVM.getBookingList(request: BookingListRequest())
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
        request.dateStart = fromDateLbl.text
        request.dateEnd = toDateLbl.text
        
        bookingListVM.getBookingList(request: request)
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToFromDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedStartDate == nil
        {
            selectedStartDate = Date()
        }
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedStartDate = date!
               
                self.fromDateLbl.text = getDateStringFromDate(date: self.selectedDate, format: "MM/dd/YYYY")
                self.toDateLbl.text = ""
            }
        }
    }
    
    @IBAction func clickToToDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedEndDate == nil
        {
            selectedEndDate = Date()
        }
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedStartDate, min: Date(), max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedEndDate = date!
              
                self.fromDateLbl.text = getDateStringFromDate(date: self.selectedDate, format: "MM/dd/YYYY")
            }
        }
    }
    
    deinit {
        log.success("BookingListVC Memory deallocated!")/
    }
    
}

extension BookingListVC : HomeBookingListDelegate {
   func didRecieveHomeBookingListResponse(response: BookingListModel) {
       bookingArr = [BookingListDataModel]()
       bookingArr = response.data
       bookingTblView.reloadData()
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
            cell.nameLbl.text = dict.name
            cell.collegeNameLbl.text = dict.schoolName
            cell.timeLbl.text = ""
             
            cell.joinBtn.isHidden = true
            cell.bookedBtn.isHidden = false
            cell.bookedBtn.setTitle(getbookingType(dict.status), for: .normal)
            cell.bookedBtn.setTitleColor(getbookingColor(dict.status), for: .normal)
            cell.timeLbl.text = displayBookingDate(dict.dateTime, callTime: dict.callTime)
            
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
            let index = filterSelectArr.firstIndex { (data) -> Bool in
                data == indexPath.row
            }
            if index != nil {
                cell.selectBtn.isSelected = true
            }
            else {
                cell.selectBtn.isSelected = false
            }
            
            filterTblViewHeightConstraint.constant = filterTblView.contentSize.height
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        vc.selectedBooking = bookingArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        printData(indexPath.row)
    }

    
    @objc func clickToSelectFilter(_ sender : UIButton) {
        let index = filterSelectArr.firstIndex { (data) -> Bool in
            data == sender.tag
        }
        if index == nil {
            filterSelectArr.append(sender.tag)
        }
        else{
            filterSelectArr.remove(at: index!)
        }
        filterTblView.reloadData()
    }
    
    
    @objc func clickToJoinCall(_ sender : UIButton) {
        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: JoinCallVC)
        JoinCallVC.setUp(0)
    }
    
}
