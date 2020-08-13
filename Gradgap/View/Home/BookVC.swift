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
    
    var selectedDate : Date!
    
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
        
        noDataLbl.isHidden = true
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
        DatePickerManager.shared.showPicker(title: "select_dob", selected: selectedDate, min: nil, max: nil) { (date, cancel) in
            if !cancel && date != nil {
                self.selectedDate = date!
               
                self.dateBtn.setTitle(getDateStringFromDate(date: self.selectedDate, format: "EEE MM/dd/YYYY"), for: .normal)
            }
        }
    }
    
    deinit {
        log.success("BookVC Memory deallocated!")/
    }
    
}

//MARK: - TableView Delegate
extension BookVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "BookingHeaderTVC") as! BookingHeaderTVC
        
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
        
        cell.timeCollectionView.delegate = self
        cell.timeCollectionView.dataSource = self
        cell.timeCollectionView.register(UINib.init(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")

       return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - CollectionView Delegate
extension BookVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }

        cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
        cell.lbl.text = "11:30 AM"
        
        cell.cancelBtn.isHidden = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 85, height: 36)
    }
    
}

