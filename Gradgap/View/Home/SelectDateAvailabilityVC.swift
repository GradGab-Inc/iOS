//
//  SelectDateAvailabilityVC.swift
//  Gradgap
//
//  Created by iMac on 9/23/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class SelectDateAvailabilityVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: Button!
    @IBOutlet weak var selectDateBtn: UIButton!
    
    var selectedDate : Date = Date()
    var arr = ["Chat","Interview Prep","Virtual Tour"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Selected Date"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "SelectDateTVC", bundle: nil), forCellReuseIdentifier: "SelectDateTVC")
        
        tblViewHeightConstraint.constant = 20
        
        tblView.reloadData()
        tblViewHeightConstraint.constant = 210 * 2
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddNewInterval(_ sender: Any) {
//        addAvailabilityData()
    }

    @IBAction func clickToSelectDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        let maxDate : Date = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        DatePickerManager.shared.showPicker(title: "Select Date", selected: selectedDate, min: maxDate, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
                
                self.selectDateBtn.setTitle(getDateStringFromDate(date: self.selectedDate, format: "MM / dd / yyyy"), for: .normal)
//                self.getMentorDetailServiceCall(true)
            }
        }
    }
    
}


//MARK: - TableView Delegate
extension SelectDateAvailabilityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2//availabilityListArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SelectDateTVC", for: indexPath) as? SelectDateTVC
            else {
            return UITableViewCell()
        }
//        let dict : AvailabilityDataModel = availabilityListArr[indexPath.row]
//        cell.weekLbl.text = dict.weekDay == -1 ? "" : getWeekDay(dict.weekDay)
//
//        cell.fromLbl.text = dict.startTime == -1 ? "" : getHourMinuteTime(dict.startTime, timeZoneOffsetInMinutes())
//        cell.toLbl.text = dict.endTime == -1 ? "" : getHourMinuteTime(dict.endTime, timeZoneOffsetInMinutes())
        
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

        tblViewHeightConstraint.constant = 210 * 2 //CGFloat(availabilityListArr.count * 265)
        return cell
    }
    
    @objc func clickToSelectFromTime(_ sender : UIButton) {
        DatePickerManager.shared.showPickerForTime(title: "Choose Start Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
//                self.availabilityListArr[sender.tag].startTime = getMinuteFromDateString(strDate: finalDate)
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectToTime(_ sender : UIButton) {
        DatePickerManager.shared.showPickerForTime(title: "Choose End Time", selected: getInitialTime(currentTime: Date(), interval: 15), min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                let finalDate = getDateStringFromDate(date: date!, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                print(finalDate)
//                self.availabilityListArr[sender.tag].endTime = getMinuteFromDateString(strDate: finalDate)
                self.tblView.reloadRows(at: [IndexPath(item: sender.tag, section: 0)], with: .automatic)
            }
            self.view.endEditing(true)
        }
    }
    
    @objc func clickToDeleteTime(_ sender : UIButton) {
//        let dict : AvailabilityDataModel = self.availabilityListArr[sender.tag]
//        if dict.id != "" {
//            showAlertWithOption("Confirmation", message: "Are you sure you want to delete this time slot?", btns: ["Cancel","Ok"], completionConfirm: {
//                self.availabilityVM.deleteAvailability(request: AvailabiltyDeleteRequest(availabilityRef: dict.id))
//            }) {
//
//            }
//        }
//        else {
//            availabilityListArr.remove(at: sender.tag)
//            tblView.reloadData()
//            tblViewHeightConstraint.constant = CGFloat(availabilityListArr.count * 265)
//        }
    }
}


//MARK: - CollectionView Delegate
extension SelectDateAvailabilityVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
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
        
//        let index = availabilityListArr[collectionView.tag].type.firstIndex { (data) -> Bool in
//            data == indexPath.row + 1
//        }
//        if index == nil {
//            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
//        }
//        else {
//            cell.backView.backgroundColor = RedColor
//        }
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let index = availabilityListArr[collectionView.tag].type.firstIndex { (data) -> Bool in
//            data == indexPath.row + 1
//        }
//        if index == nil {
//            self.availabilityListArr[collectionView.tag].type.append(indexPath.row + 1)
//        }
//        else {
//            self.availabilityListArr[collectionView.tag].type.remove(at: index!)
//        }
        tblView.reloadRows(at: [IndexPath(item: collectionView.tag, section: 0)], with: .automatic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 45)
    }
    
}

