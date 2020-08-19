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
    
    var dateListVM : AvailabilityListViewModel = AvailabilityListViewModel()
    var availabilityListArr : [AvailabilityDataModel] = [AvailabilityDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = getDateStringFromDate(date: Date(), format: "EE, MMMM dd, yyyy")
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "CalenderListTVC", bundle: nil), forCellReuseIdentifier: "CalenderListTVC")
        
        dateListVM.delegate = self
        dateListVM.availabilityList()
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToUpdateAvailabilityBack(_ sender: Any) {
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
         
        if availabilityListArr.count == 0 {
            updateBtn.setTitle("Set Availability", for: .normal)
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
        
        cell.timeLbl.text = timeSloteArr[indexPath.row]
        
//        if indexPath.row == 1 || indexPath.row == 7 {
//            cell.backView.isHidden = false
//        }
//        else {
//            cell.backView.isHidden = true
//        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
        
}
