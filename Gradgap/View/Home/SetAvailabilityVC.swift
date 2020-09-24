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
    @IBOutlet weak var submitBtn: Button!
    
    var dateListVM : AvailabilityListViewModel = AvailabilityListViewModel()
    var availabilityVM : SetAvailabilityViewModel = SetAvailabilityViewModel()
    var arr = ["Chat","Interview Prep","Virtual Tour"]
    var availabilityListArr : [AvailabilityDataModel] = [AvailabilityDataModel]()
    
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
        
        dateListVM.delegate = self
        dateListVM.availabilityList()
        
        tblViewHeightConstraint.constant = 20
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddNewInterval(_ sender: Any) {
        addAvailabilityData()
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if availabilityListArr.count != 0 {
            var setArr : [AvailabiltyRequest] = [AvailabiltyRequest]()
            var updateArr : [AvailabiltyRequest] = [AvailabiltyRequest]()
            for item in availabilityListArr {
                if item.weekDay == -1 || item.startTime == -1 || item.endTime == -1 || item.type == []  {
                    displayToast("Please fill the above data")
                    return
                }
                else {
                    var dict : AvailabiltyRequest = AvailabiltyRequest()
                    if item.id == "" {
                        dict.startTime = item.startTime
                        dict.endTime = item.endTime
                        dict.weekDay = item.weekDay
                        dict.type = item.type
                        setArr.append(dict)
                    }
                    else {
                        dict.availabilityRef = item.id
                        dict.startTime = item.startTime
                        dict.endTime = item.endTime
                        dict.weekDay = item.weekDay
                        dict.type = item.type
                        updateArr.append(dict)
                    }
                }
            }
            if setArr.count != 0 {
                let request = SetAvailabiltyRequest(availability: setArr, timezone: timeZoneOffsetInMinutes())
                availabilityVM.setAvailability(request: request)
            }
            if updateArr.count != 0 {
                let request = SetAvailabiltyRequest(availability: updateArr, timezone: timeZoneOffsetInMinutes())
                availabilityVM.updateAvailability(request: request)
            }
        }
    }
    
    func addAvailabilityData() {
        submitBtn.isHidden = false
        if let lastData = availabilityListArr.last {
            if lastData.weekDay == -1 || lastData.startTime == -1 || lastData.endTime == -1 || lastData.type == []  {
                displayToast("Please fill the above data")
            }
            else {
                let availability : AvailabilityDataModel = AvailabilityDataModel.init()
                availabilityListArr.append(availability)
                tblView.reloadData()
                tblViewHeightConstraint.constant = CGFloat(availabilityListArr.count * 265)
            }
        }
        else {
            let availability : AvailabilityDataModel = AvailabilityDataModel.init()
            availabilityListArr.append(availability)
            tblView.reloadData()
            tblViewHeightConstraint.constant = CGFloat(availabilityListArr.count * 265)
        }
    }
    
    deinit {
        log.success("SetAvailabilityVC Memory deallocated!")/
    }
}

extension SetAvailabilityVC : SetAvailabilityDelegate, AvailabilityListDelegate {
    func didRecieveAvailabilityListResponse(response: AvailabiltyListModel) {
        availabilityListArr = response.data
        tblView.reloadData()
    }
    
    func didRecieveSetAvailabilityResponse(response: SuccessModel) {
        displayToast(response.message)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTOR_BOOKED_DATA), object: nil)
    }
    
    func didRecieveDeleteAvailabilityResponse(response: SuccessModel) {
        dateListVM.availabilityList()
    }
    
    func didRecieveUpdateAvailabilityResponse(response: AvailabiltyListModel) {
        self.navigationController?.popViewController(animated: true)
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
        
        cell.fromLbl.text = dict.startTime == -1 ? "" : getHourMinuteTime(dict.startTime, timeZoneOffsetInMinutes())
        cell.toLbl.text = dict.endTime == -1 ? "" : getHourMinuteTime(dict.endTime, timeZoneOffsetInMinutes())
        
        cell.weekBtn.tag = indexPath.row
        cell.weekBtn.addTarget(self, action: #selector(self.clickToSelectWeek), for: .touchUpInside)
        
        cell.fromBtn.tag = indexPath.row
        cell.fromBtn.addTarget(self, action: #selector(self.clickToSelectFromTime), for: .touchUpInside)
        
        cell.toBtn.tag = indexPath.row
        cell.toBtn.addTarget(self, action: #selector(self.clickToSelectToTime), for: .touchUpInside)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.clickToDeleteTime), for: .touchUpInside)
        
        cell.availableCollectionView.tag = indexPath.row
        cell.availableCollectionView.delegate = self
        cell.availableCollectionView.dataSource = self
        cell.availableCollectionView.register(UINib.init(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        cell.availableCollectionView.reloadData()

        tblViewHeightConstraint.constant = CGFloat(availabilityListArr.count * 265)
        return cell
    }
        
    @objc func clickToSelectWeek(_ sender : UIButton) {
        DatePickerManager.shared.showPicker(title: "Select Week", selected: "Monday", strings: weekArr) { [weak self](week, index, success) in
            if week != nil {
                self?.availabilityListArr[sender.tag].weekDay = index
                
                self?.availabilityListArr[sender.tag].startTime = -1
                self?.availabilityListArr[sender.tag].endTime = -1
                self?.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self?.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectFromTime(_ sender : UIButton) {
        if self.availabilityListArr[sender.tag].weekDay == -1 {
            displayToast("Please select week day first.")
            return
        }
        DatePickerManager.shared.showPickerForTime(title: "Choose Start Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.availabilityListArr[sender.tag].endTime = -1
                let totalMin = getMinuteFromDate(date: date!)
                self.availabilityListArr[sender.tag].startTime = self.isTrueTime(totalMin, sender.tag, true) ? totalMin : -1
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
        
//        DatePickerManager.shared.showPickerForTime(title: "Choose Start Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
//            if !cancel && date != nil {
//                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
//                print(finalDate)
//                self.availabilityListArr[sender.tag].startTime = getMinuteFromDateString(strDate: finalDate)
//                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
//            }
//            self.view.endEditing(true)
//        }
    }
    
    @objc func clickToSelectToTime(_ sender : UIButton) {
       if self.availabilityListArr[sender.tag].startTime == -1 {
            displayToast("Please select start time first.")
            return
        }
        
        DatePickerManager.shared.showPickerForTime(title: "Choose End Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let totalMin = getMinuteFromDate(date: date!)
                if getDateFromMinute(self.availabilityListArr[sender.tag].startTime) < getDateFromMinute(totalMin) {
                    self.availabilityListArr[sender.tag].endTime = self.isTrueTime(totalMin, sender.tag, false) ? totalMin : -1
                    self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
                }else{
                    displayToast("End time must be greater then start time.")
                }
                
            }
            self.view.endEditing(true)
        }
        
        
//        DatePickerManager.shared.showPickerForTime(title: "Choose End Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
//            if !cancel && date != nil {
//                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
//                print(finalDate)
//                self.availabilityListArr[sender.tag].endTime = getMinuteFromDateString(strDate: finalDate)
//                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
//            }
//            self.view.endEditing(true)
//        }
    }
    
    func isTrueTime(_ min : Int, _ tag : Int, _ isStart: Bool) -> Bool {
        if availabilityListArr.count > 1 {
            
        }
        let index = availabilityListArr.firstIndex { (data) -> Bool in
            data.weekDay == availabilityListArr[tag].weekDay
        }
        if index != nil {
            for item in availabilityListArr {
                if item.weekDay == availabilityListArr[tag].weekDay {
                    if item.startTime != -1 && item.endTime != -1 {
                        print(item.startTime)
                        print(item.endTime)
                        print(min)
                        
                        let startDate = getDateFromMinute(item.startTime)
                        let endDate = getDateFromMinute(item.endTime)
                        
                        
                        if isStart {
                            let selectStartTime = getDateFromMinute(min)
                            if ((selectStartTime >= startDate) && (selectStartTime < endDate)) || ((selectStartTime < startDate) && (selectStartTime > endDate)) {
                                displayToast("Time over-ride")
                                return false
                            }
                            if self.availabilityListArr[tag].endTime != -1 {
                                let selectEndTime = getDateFromMinute(min)
                                if ((selectStartTime < startDate) && (selectEndTime > endDate)) || ((selectStartTime < startDate) && (selectEndTime < endDate)) || ((selectStartTime > startDate) && (selectEndTime > endDate)) {
                                    displayToast("Time over-ride")
                                    return false
                                }
                            }
                        }
                        else {
                            let selectStartTime = getDateFromMinute(self.availabilityListArr[tag].startTime)
                            let selectEndTime = getDateFromMinute(min)
                            
                            if ((selectStartTime > startDate) && (selectStartTime < endDate)) || ((selectStartTime < startDate) && (selectEndTime > endDate)) || ((selectStartTime < startDate) && (selectEndTime < endDate) && (selectEndTime > startDate)) || ((selectStartTime > startDate) && (selectEndTime > endDate) && (selectStartTime < endDate)) {
                                displayToast("Time over-ride")
                                return false
                            }
                        }
                    }
                }
            }
            return true
        }
        else {
            return true
        }
    }
    
    func isTrueTime1(_ min: Int, _ tag: Int, _ isStart: Bool) -> Bool {
        if availabilityListArr.count > 1 {
            for item in availabilityListArr {
                if item.startTime != -1 && item.endTime != -1 {
                    print(item.startTime)
                    print(item.endTime)
                    print(min)
                    
                    let startDate = getDateFromMinute(item.startTime)
                    let endDate = getDateFromMinute(item.endTime)
                    
                    if isStart {
                        let selectStartTime = getDateFromMinute(min)
                        if ((selectStartTime >= startDate) && (selectStartTime < endDate)) || ((selectStartTime < startDate) && (selectStartTime > endDate)) {
                            displayToast("Time over-ride")
                            return false
                        }
                        if self.availabilityListArr[tag].endTime != -1 {
                            let selectEndTime = getDateFromMinute(min)
                            if ((selectStartTime < startDate) && (selectEndTime > endDate)) || ((selectStartTime < startDate) && (selectEndTime < endDate) && (selectEndTime > startDate)) || ((selectStartTime > startDate) && (selectEndTime > endDate) && (selectStartTime < endDate)) || (selectEndTime == endDate) {
                                displayToast("Time over-ride")
                                return false
                            }
                        }
                    }
                    else {
                        let selectStartTime = getDateFromMinute(self.availabilityListArr[tag].startTime)
                        let selectEndTime = getDateFromMinute(min)
                        
                        if ((selectStartTime > startDate) && (selectStartTime < endDate)) || ((selectStartTime < startDate) && (selectEndTime > endDate)) || ((selectStartTime < startDate) && (selectEndTime < endDate) && (selectEndTime > startDate)) || ((selectStartTime > startDate) && (selectEndTime > endDate) && (selectStartTime < endDate)) || (selectEndTime == endDate) {
                            displayToast("Time over-ride")
                            return false
                        }
                    }
                }
            }
            return true
        }
        else {
            return true
        }
    }
    
    @objc func clickToDeleteTime(_ sender : UIButton) {
        let dict : AvailabilityDataModel = self.availabilityListArr[sender.tag]
        if dict.id != "" {
            showAlertWithOption("Confirmation", message: "Are you sure you want to delete this time slot?", btns: ["Cancel","Ok"], completionConfirm: {
                self.availabilityVM.deleteAvailability(request: AvailabiltyDeleteRequest(availabilityRef: dict.id))
            }) {
                
            }
        }
        else {
            showAlertWithOption("Confirmation", message: "Are you sure you want to delete this time slot?", btns: ["Cancel","Ok"], completionConfirm: {
                self.availabilityListArr.remove(at: sender.tag)
                self.tblView.reloadData()
                self.tblViewHeightConstraint.constant = CGFloat(self.availabilityListArr.count * 265)
            }) {
                
            }
        }
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
        cell.backView.cornerRadius = 5
        
        let index = availabilityListArr[collectionView.tag].type.firstIndex { (data) -> Bool in
            data == indexPath.row + 1
        }
        if index == nil {
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        }
        else {
            cell.backView.backgroundColor = RedColor
        }
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = availabilityListArr[collectionView.tag].type.firstIndex { (data) -> Bool in
            data == indexPath.row + 1
        }
        if index == nil {
            self.availabilityListArr[collectionView.tag].type.append(indexPath.row + 1)
        }
        else {
            self.availabilityListArr[collectionView.tag].type.remove(at: index!)
        }
        tblView.reloadRows(at: [IndexPath(item: collectionView.tag, section: 0)], with: .automatic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 45)
    }
    
}

