//
//  BookVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class BookVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var selectedType : Int = 1
    var selectedChatTime : Int = 0
    var selectedDate : Date = Date()
    var mentorListVM : MentorListViewModel = MentorListViewModel()
    var mentorListArr : [MentorSectionModel] = [MentorSectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Book"
        navigationBar.backBtn.setImage(UIImage.init(named: "ic_close-1"), for: .normal)
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "CustomBookTVC", bundle: nil), forCellReuseIdentifier: "CustomBookTVC")
        tblView.register(UINib(nibName: "BookingHeaderTVC", bundle: nil), forCellReuseIdentifier: "BookingHeaderTVC")
        dateBtn.setTitle(getDateStringFromDate(date: Date(), format: "EEE MM/dd/YYYY"), for: .normal)
        
        noDataLbl.isHidden = false
        mentorListVM.delegate = self
        serviceCall()
        
    }
    
    func serviceCall() {
        if selectedType == 1 {
            mentorListVM.getMentorList(request: MentorListRequest(callType: 1, callTime: getCallTime(selectedChatTime), dateTime: getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")))
        }
        else if selectedType == 2  {
            mentorListVM.getMentorList(request: MentorListRequest(callType: 2, callTime: 60, dateTime: getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")))
        }
        else {
            mentorListVM.getMentorList(request: MentorListRequest(callType: 3, callTime: 45, dateTime: getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")))
        }
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectDate(_ sender: Any) {
        self.view.endEditing(true)
        if selectedDate == nil
        {
            selectedDate = Date()
        }
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: Date(), max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
               
                self.dateBtn.setTitle(getDateStringFromDate(date: self.selectedDate, format: "EEE MM/dd/YYYY"), for: .normal)
                self.serviceCall()
            }
        }
    }
    
    deinit {
        log.success("BookVC Memory deallocated!")/
    }
    
}

extension BookVC : MentorListDelegate {
    func didRecieveMentorListResponse(response: MentorListModel) {
        mentorListArr = [MentorSectionModel]()
        mentorListArr = response.data
        
        if mentorListArr.count == 0 {
            noDataLbl.isHidden = false
        }
        else {
            noDataLbl.isHidden = true
        }
        
        tblView.reloadData()
    }
}


//MARK: - TableView Delegate
extension BookVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mentorListArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentorListArr[section].data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "BookingHeaderTVC") as! BookingHeaderTVC
        header.headerLbl.text = mentorListArr[section].id
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomBookTVC", for: indexPath) as? CustomBookTVC
            else {
            return UITableViewCell()
        }
        
        let dict : MentorListDataModel = mentorListArr[indexPath.section].data[indexPath.row]
        cell.nameLbl.text = dict.name
        cell.collegeNameLbl.text = dict.schoolName
        cell.ratingView.rating = Double(dict.averageRating)
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString: dict.image)
        
        cell.arrData = dict.availableTimings
        cell.timeCollectionView.reloadData()

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
        
        vc.selectedUserId = mentorListArr[indexPath.section].data[indexPath.row].id
        vc.selectedType = selectedType
        if selectedType == 1 {
            vc.selectedCallTime = getCallTime(selectedChatTime)
        }
        else if selectedType == 2  {
            vc.selectedCallTime = 60
        }
        else {
            vc.selectedCallTime = 45
        }
        vc.selectedDate = selectedDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BookVC : CustomBookTVCDelegate {
    func didRecieveCustomBookTVCResponse(_ id : String,_ timeSlote: Int) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
        
        vc.selectedUserId = id
        vc.selectedType = selectedType
        if selectedType == 1 {
            vc.selectedCallTime = getCallTime(selectedChatTime)
        }
        else if selectedType == 2  {
            vc.selectedCallTime = 60
        }
        else {
            vc.selectedCallTime = 45
        }
        vc.selectedDate = selectedDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

