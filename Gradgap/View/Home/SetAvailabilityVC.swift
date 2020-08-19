//
//  SetAvailabilityVC.swift
//  Gradgap
//
//  Created by iMac on 13/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class SetAvailabilityVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    
    var availabilityVM : SetAvailabilityViewModel = SetAvailabilityViewModel()
    var arr = ["Chat","Interview Prep","Virtual Tour"]
    var availabilityListArr : [AvailabilityDataModel] = [AvailabilityDataModel]()
    var setCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Set Availability"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "SetAvailabilityTVC", bundle: nil), forCellReuseIdentifier: "SetAvailabilityTVC")
        availabilityVM.delegate = self
        
        if availabilityListArr.count == 0 {
            let availability : AvailabilityDataModel = AvailabilityDataModel.init()
            availabilityListArr.append(availability)
            setCount = availabilityListArr.count
            tblView.reloadData()
            tblViewHeightConstraint.constant = CGFloat(setCount * 265)
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddNewInterval(_ sender: Any) {
        addAvailabilityData()
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
    }
    
    func addAvailabilityData() {
        let availability : AvailabilityDataModel = AvailabilityDataModel.init()
        availabilityListArr.append(availability)
        setCount = availabilityListArr.count
        tblView.reloadData()
        tblViewHeightConstraint.constant = CGFloat(setCount * 265)
    }
    
    deinit {
        log.success("SetAvailabilityVC Memory deallocated!")/
    }
    
}

extension SetAvailabilityVC : SetAvailabilityDelegate {
    func didRecieveSetAvailabilityResponse(response: AvailabiltyListModel) {
        
    }
    
    func didRecieveDeleteAvailabilityResponse(response: SuccessModel) {
        
    }
    
    func didRecieveUpdateAvailabilityResponse(response: AvailabiltyListModel) {
        
    }
}

//MARK: - TableView Delegate
extension SetAvailabilityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availabilityListArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SetAvailabilityTVC", for: indexPath) as? SetAvailabilityTVC
            else {
            return UITableViewCell()
        }
        
        let dict : AvailabilityDataModel = availabilityListArr[indexPath.row]
        cell.weekLbl.text = dict.weekDay == -1 ? "" : getWeekDay(dict.weekDay)
        cell.fromLbl.text = dict.startTime == "" ? "" : getDateStringFromDateString(strDate: dict.startTime, formate: "hh:mm a")
        cell.toLbl.text = dict.endTime == "" ? "" : getDateStringFromDateString(strDate: dict.endTime, formate: "hh:mm a")
        
        cell.weekBtn.tag = indexPath.row
        cell.weekBtn.addTarget(self, action: #selector(self.clickToSelectWeek), for: .touchUpInside)
        
        cell.fromBtn.tag = indexPath.row
        cell.fromBtn.addTarget(self, action: #selector(self.clickToSelectFromTime), for: .touchUpInside)
        
        cell.toBtn.tag = indexPath.row
        cell.toBtn.addTarget(self, action: #selector(self.clickToSelectToTime), for: .touchUpInside)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.clickToDeleteTime), for: .touchUpInside)
        
        cell.availableCollectionView.delegate = self
        cell.availableCollectionView.dataSource = self
        cell.availableCollectionView.register(UINib.init(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")

        tblViewHeightConstraint.constant = CGFloat(setCount * 265)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func clickToSelectWeek(_ sender : UIButton)  {
        DatePickerManager.shared.showPicker(title: "Select Week", selected: "Monday", strings: weekArr) { [weak self](week, index, success) in
            if week != nil {
                self?.availabilityListArr[sender.tag].weekDay = index
                self?.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self?.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectFromTime(_ sender : UIButton)  {
        DatePickerManager.shared.showPickerForTime(title: "Choose Start Time", selected: Date(), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
                self.availabilityListArr[sender.tag].startTime = finalDate
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectToTime(_ sender : UIButton)  {
        DatePickerManager.shared.showPickerForTime(title: "Choose End Time", selected: Date(), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
                self.availabilityListArr[sender.tag].endTime = finalDate
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToDeleteTime(_ sender : UIButton) {
        setCount = setCount - 1
        tblView.reloadData()
        tblViewHeightConstraint.constant = CGFloat(setCount * 265)
    }
    
    
}

//MARK: - CollectionView Delegate
extension SetAvailabilityVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
        cell.lbl.text = arr[indexPath.row]
//        cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        cell.backView.cornerRadius = 5
        
        if availabilityListArr[indexPath.section].type == indexPath.row + 1 {
            cell.backView.backgroundColor = RedColor
        }
        else {
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        }
        
//
//        if indexPath.row == 0 {
//            if availabilityListArr[indexPath.section].type == 3 {
//                cell.backView.backgroundColor = RedColor
//            }
//        }
//        else if indexPath.row == 1 {
//            if availabilityListArr[indexPath.section].type == 2 {
//                cell.backView.backgroundColor = RedColor
//            }
//        }
//        else if indexPath.row == 2 {
//            if availabilityListArr[indexPath.section].type == 1 {
//                cell.backView.backgroundColor = RedColor
//            }
//        }
//        else {
//            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
//        }
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            self.availabilityListArr[indexPath.section].type = 1
//        }
//        else if indexPath.row == 1 {
//            self.availabilityListArr[indexPath.section].type = 2
//        }
//        else if indexPath.row == 2 {
//            self.availabilityListArr[indexPath.section].type = 3
//        }
        self.availabilityListArr[indexPath.section].type = indexPath.row + 1
        self.tblView.reloadRows(at: [IndexPath(item: indexPath.section, section: 0)], with: .automatic)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width/3, height: 45)
    }
    
}

