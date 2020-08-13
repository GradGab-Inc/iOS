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
       
        setCount = 1
        tblView.reloadData()
        tblViewHeightConstraint.constant = CGFloat(setCount * 265)
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddNewInterval(_ sender: Any) {
        setCount = setCount + 1
        tblView.reloadData()
        tblViewHeightConstraint.constant = CGFloat(setCount * 265)
    }
    
    deinit {
        log.success("SetAvailabilityVC Memory deallocated!")/
    }
    
}


//MARK: - TableView Delegate
extension SetAvailabilityVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "SetAvailabilityTVC", for: indexPath) as? SetAvailabilityTVC
            else {
            return UITableViewCell()
        }
        
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
        DatePickerManager.shared.showPicker(title: "Select Week", selected: "91", strings: weekArr) { [weak self](school, index, success) in
            if school != nil {
               // self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectFromTime(_ sender : UIButton)  {
        DatePickerManager.shared.showPicker(title: "Select Time", selected: "91", strings: ["08:00 AM","09:00 AM","10:00 AM"]) { [weak self](school, index, success) in
            if school != nil {
               // self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @objc func clickToSelectToTime(_ sender : UIButton)  {
        DatePickerManager.shared.showPicker(title: "Select Time", selected: "91", strings: ["08:00 AM","09:00 AM","10:00 AM"]) { [weak self](school, index, success) in
            if school != nil {
               // self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
        cell.lbl.text = "Virtual Tour"
        
        cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        cell.backView.borderColorTypeAdapter = 0
        cell.backView.cornerRadius = 5
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width/3, height: 45)
    }
    
}

