//
//  UpdateAvailabilityVC.swift
//  Gradgap
//
//  Created by iMac on 27/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class UpdateAvailabilityVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    
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
        navigationBar.headerLbl.text = "Update Availability"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "SetAvailabilityTVC", bundle: nil), forCellReuseIdentifier: "SetAvailabilityTVC")
        
        dateListVM.delegate = self
        dateListVM.availabilityList()
        
        availabilityVM.delegate = self
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if availabilityListArr.count != 0 {
            var dictArr : [AvailabiltyRequest] = [AvailabiltyRequest]()
            for item in availabilityListArr {
                var dict : AvailabiltyRequest = AvailabiltyRequest()
                dict.availabilityRef = item.id
                dict.startTime = item.startTime
                dict.endTime = item.endTime
                dict.weekDay = item.weekDay
                dict.type = item.type
                dictArr.append(dict)
            }
            let request = SetAvailabiltyRequest(availability: dictArr, timezone: timeZoneOffsetInMinutes())
            availabilityVM.updateAvailability(request: request)
        }
    }
    
}


extension UpdateAvailabilityVC : SetAvailabilityDelegate, AvailabilityListDelegate {
    func didRecieveAvailabilityListResponse(response: AvailabiltyListModel) {
        availabilityListArr = response.data
        tblView.reloadData()
        
        if availabilityListArr.count == 0 {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didRecieveSetAvailabilityResponse(response: SuccessModel) {
        displayToast(response.message)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func didRecieveDeleteAvailabilityResponse(response: SuccessModel) {
        dateListVM.availabilityList()
    }
    
    func didRecieveUpdateAvailabilityResponse(response: AvailabiltyListModel) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - TableView Delegate
extension UpdateAvailabilityVC : UITableViewDelegate, UITableViewDataSource {
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
        print(dict)
        cell.weekLbl.text = dict.weekDay == -1 ? "" : getWeekDay(dict.weekDay)
        
        cell.fromLbl.text = getHourMinuteTime(dict.startTime, dict.timezone)
        cell.toLbl.text = getHourMinuteTime(dict.endTime, dict.timezone)
                
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
        DatePickerManager.shared.showPickerForTime(title: "Choose Start Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
                self.availabilityListArr[sender.tag].startTime = getMinuteFromDateString(strDate: finalDate)
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectToTime(_ sender : UIButton)  {
        DatePickerManager.shared.showPickerForTime(title: "Choose End Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
                self.availabilityListArr[sender.tag].endTime = getMinuteFromDateString(strDate: finalDate)
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToDeleteTime(_ sender : UIButton) {
        showAlertWithOption(getTranslate("Confirmation"), message: "Are you sure you want to delete this time slot...?", btns: [getTranslate("Cancel"),getTranslate("Ok")], completionConfirm: {
            
            let dict : AvailabilityDataModel = self.availabilityListArr[sender.tag]
            self.availabilityVM.deleteAvailability(request: AvailabiltyDeleteRequest(availabilityRef: dict.id))
            
        }) {
            
        }
        
    }
    
}

//MARK: - CollectionView Delegate
extension UpdateAvailabilityVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
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
        
        if availabilityListArr[collectionView.tag].type == indexPath.row + 1 {
            cell.backView.backgroundColor = RedColor
        }
        else {
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        }
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.availabilityListArr[collectionView.tag].type = indexPath.row + 1
        tblView.reloadRows(at: [IndexPath(item: collectionView.tag, section: 0)], with: .automatic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 45)
    }
    
}


extension Date{
  //MARK:- sainiHoursFrom
  public func sainiMinFrom(_ date: Date) -> Double {
    return Double(Calendar.current.dateComponents([.minute], from: date, to: self).minute!)
  }
  func toString( dateFormat format : String ) -> String
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: self)
  }
}
