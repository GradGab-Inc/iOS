//
//  BookingListVC.swift
//  Gradgap
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

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
    let JoinCallVC : JoinCallView = JoinCallView.instanceFromNib() as! JoinCallView
    
    
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
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        filterBackView.isHidden = true
    }
    
    @IBAction func clickToFromDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
               
                self.fromDateLbl.text = getDateStringFromDate(date: self.selectedDate, format: "MM/dd/YYYY")
            }
        }
    }
    
    @IBAction func clickToToDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedDate == nil
        {
            selectedDate = Date()
        }
//        let maxDate : Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
              
                self.fromDateLbl.text = getDateStringFromDate(date: self.selectedDate, format: "MM/dd/YYYY")
            }
        }
    }
    
}

//MARK: - TableView Delegate
extension BookingListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bookingTblView {
            return 8
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
