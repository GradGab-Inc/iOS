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
    @IBOutlet weak var noDataLbl: UILabel!
    
    var dataModel : EarningResponse = EarningResponse()
    var earningListVM : EarningViewModel = EarningViewModel()
    var earningArr : [TransactionListModel] = [TransactionListModel]()
    var totalData : Total = Total.init()
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var currentPage : Int = 1
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
        
        earningListVM.delegate = self
        earningListVM.couponList(request: MorePageRequest(page: currentPage))
        
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
        setupData()
    }
    
    //MARK: - Refresh data
    @objc func refreshDataSetUp() {
        refreshControl.endRefreshing()
        currentPage = 1
        earningListVM.couponList(request: MorePageRequest(page: currentPage))
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
        log.success("MyEarningVC Memory deallocated!")/
    }
    
}

extension MyEarningVC : EarningListDelegate {
    func didRecieveEarningListResponse(response: EarningResponse) {
        dataModel = response
        if currentPage == 1 {
            earningArr = [TransactionListModel]()
            totalData = dataModel.data?.total ?? Total.init()
        }
        for item in response.data?.earningList ?? [TransactionListModel].init() {
            earningArr.append(item)
        }
        tblView.reloadData()
        setupData()
        noDataLbl.isHidden = earningArr.count == 0 ? false : true
    }
    
    func setupData() {
        earningLbl.text = "$\(dataModel.data?.total?.earnings ?? 0)"
        totalBookingLbl.text = "\(dataModel.data?.total?.count ?? 0)"
    }
    
}

//MARK: - TableView Delegate
extension MyEarningVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return earningArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earningArr[section].data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "TransactionHeaderTVC") as! TransactionHeaderTVC
        
        let dict : TransactionListModel = earningArr[section]
        header.headerLbl.text = getDifferenceFromCurrentTimeInDays(dict.id)
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
        
        let dict : TransactionListDataModel = earningArr[indexPath.section].data[indexPath.row]
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
        cell.nameLbl.text = dict.name
        cell.priceLbl.text = "$\(dict.amount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if earningArr.count - 2 == indexPath.row {
            if dataModel.hasMore {
                currentPage = currentPage + 1
                earningListVM.couponList(request: MorePageRequest(page: currentPage))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
