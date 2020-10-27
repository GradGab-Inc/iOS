//
//  TransactionVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class TransactionVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var dataModel : TransactionResponse = TransactionResponse()
    var transactionVM : TransactionListViewModel = TransactionListViewModel()
    var transactionListArr : [TransactionListModel] = [TransactionListModel]()
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var currentPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Transactions"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "TransactionTVC", bundle: nil), forCellReuseIdentifier: "TransactionTVC")
        tblView.register(UINib(nibName: "TransactionHeaderTVC", bundle: nil), forCellReuseIdentifier: "TransactionHeaderTVC")
        
        transactionVM.delegate = self
        transactionVM.getTransactionList(request: MorePageWithLimitRequest(page: currentPage, limit: 100))
        
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
     @objc func refreshDataSetUp() {
         refreshControl.endRefreshing()
         currentPage = 1
         transactionVM.getTransactionList(request: MorePageWithLimitRequest(page: currentPage, limit: 100))
     }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        log.success("TransactionVC Memory deallocated!")/
    }
    
}

extension TransactionVC : TransactionListDelegate {
    func didRecieveTransactionListResponse(response: TransactionResponse) {
        dataModel = response
        if currentPage == 1 {
            transactionListArr = [TransactionListModel]()
        }
        for item in response.data {
            transactionListArr.append(item)
        }
        DispatchQueue.main.async { [weak self] in
          self?.tblView.reloadData()
        }
        noDataLbl.isHidden = transactionListArr.count == 0 ? false : true
    }
}


//MARK: - TableView Delegate
extension TransactionVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionListArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionListArr[section].data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "TransactionHeaderTVC") as! TransactionHeaderTVC
        
        let dict : TransactionListModel = transactionListArr[section]
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
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "TransactionTVC", for: indexPath) as? TransactionTVC
            else {
            return UITableViewCell()
        }
        
        let dict : TransactionListDataModel = transactionListArr[indexPath.section].data[indexPath.row]
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  dict.image)
        cell.nameLbl.text = "\(dict.firstName) \(dict.lastName != "" ? "\(dict.lastName.first!.uppercased())." : "")"
        cell.collegeNameLbl.text = dict.school.first?.name ?? ""
        cell.priceLbl.text = "$\(String(format: "%.2f", dict.amount))" //"$\(dict.amount ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if transactionListArr.count - 2 == indexPath.row {
            if dataModel.hasMore {
                currentPage = currentPage + 1
                transactionVM.getTransactionList(request: MorePageWithLimitRequest(page: currentPage, limit: 100))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
        vc.isFromTransaction = true
        vc.selectedTransaction = transactionListArr[indexPath.section].data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
