//
//  MyEarningVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MyEarningVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var earningLbl: UILabel!
    @IBOutlet weak var totalBookingLbl: UILabel!
    
    @IBOutlet var filterBackView: UIView!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    
    var selectedStartDate = Date()
    var selectedEndDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
     override func viewWillAppear(_ animated: Bool) {
         navigationBar.headerLbl.text = "My Earnings"
         navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
         navigationBar.filterBtn.addTarget(self, action: #selector(self.clickToFilter), for: .touchUpInside)
     }
     
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "MyEarningTVC", bundle: nil), forCellReuseIdentifier: "MyEarningTVC")
        tblView.register(UINib(nibName: "TransactionHeaderTVC", bundle: nil), forCellReuseIdentifier: "TransactionHeaderTVC")
        
        filterBackView.isHidden = true
        self.fromDateLbl.text = getDateStringFromDate(date: selectedStartDate, format: "MM/dd/YYYY")
        selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedStartDate) ?? Date()
        self.toDateLbl.text = getDateStringFromDate(date: selectedEndDate, format: "MM/dd/YYYY")
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
    
    @IBAction func clickToFromDate(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedStartDate, min: nil, max: nil) { (date, cancel) in
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
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedEndDate, min: maxDate, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedEndDate = date!
            
                self.toDateLbl.text = getDateStringFromDate(date: self.selectedEndDate, format: "MM/dd/YYYY")
            }
        }
    }
    
    deinit {
        log.success("MyEarningVC Memory deallocated!")/
    }
    
}

//MARK: - TableView Delegate
extension MyEarningVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "TransactionHeaderTVC") as! TransactionHeaderTVC
        
        header.headerLbl.text = "May 4, 2020"
        if section == 0 {
            header.topLineView.isHidden = true
        }
        else {
            header.topLineView.isHidden = false
        }
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "MyEarningTVC", for: indexPath) as? MyEarningTVC
            else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
