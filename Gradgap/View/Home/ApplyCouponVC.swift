//
//  ApplyCouponVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ApplyCouponVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var dataModel : CouponListResponse = CouponListResponse()
    var couponListVM : CouponListViewModel = CouponListViewModel()
    var couponArr : [CouponListDataResponse] = [CouponListDataResponse]()
    var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var currentPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Apply Coupon"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "CouponTVC", bundle: nil), forCellReuseIdentifier: "CouponTVC")
        
        couponListVM.delegate = self
        couponListVM.couponList(request: MorePageRequest(page: currentPage))
        
        refreshControl.tintColor = AppColor
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
     @objc func refreshDataSetUp() {
         refreshControl.endRefreshing()
         currentPage = 1
         couponListVM.couponList(request: MorePageRequest(page: currentPage))
     }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        log.success("ApplyCouponVC Memory deallocated!")/
    }
}

extension ApplyCouponVC : CouponListDelegate {
    func didRecieveCouponListResponse(response: CouponListResponse) {
        dataModel = response
        if currentPage == 1 {
            couponArr = [CouponListDataResponse]()
        }
        for item in response.data {
            couponArr.append(item)
        }
        tblView.reloadData()
        noDataLbl.isHidden = couponArr.count == 0 ? false : true
    }
}


//MARK: - TableView Delegate
extension ApplyCouponVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CouponTVC", for: indexPath) as? CouponTVC
            else {
            return UITableViewCell()
        }
        
        let dict : CouponListDataResponse = couponArr[indexPath.row]
        cell.noteLbl.text = "Note: \(dict.note)"
        cell.perecentLbl.text = "\(dict.amountOff)%"
        
        cell.applyBtn.tag = indexPath.row
        cell.applyBtn.addTarget(self, action: #selector(self.clickToApply), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if couponArr.count - 2 == indexPath.row {
            if dataModel.hasMore {
                currentPage = currentPage + 1
                couponListVM.couponList(request: MorePageRequest(page: currentPage))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.GET_COUPON_DATA), object: couponArr[indexPath.row])
    }
    
    @objc func clickToApply(_ sender : UIButton) {
        
    }
    
}
