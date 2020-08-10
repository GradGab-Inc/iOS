//
//  MentorsProfileVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MentorsProfileVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var courceNameLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mentorCollectionView: UICollectionView!
    
    var selectedDate : Date!
    var selectedIndex : [Int] = [Int]()
    var topicMentor = ["Social Life","Academics","Applying with Low Test Score"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Profile"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        
        timeCollectionView.reloadData()
        timeCollectionViewHeightConstraint.constant = timeCollectionView.contentSize.height
    }
    
    //MARK: - configUI
    func configUI() {
        timeCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        mentorCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        noDataLbl.isHidden = true
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
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
              
                self.dateBtn.setTitle(getDateStringFromDate(date: self.selectedDate, format: "MMMM dd, yyyy"), for: .normal)
            }
        }
    }
    
    @IBAction func clickToBookMentor(_ sender: Any) {
        
    }

}


//MARK: - CollectionView Delegate
extension MentorsProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeCollectionView {
            return 6
        }
        else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timeCollectionView {
            guard let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
            cell.lbl.text = "11:30 AM"
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data == indexPath.row
            }
            if index != nil {
                cell.backView.backgroundColor = LightBlueColor
                cell.backView.borderColorTypeAdapter = 7
            }
            else {
                cell.backView.backgroundColor = AppColor
                cell.backView.borderColorTypeAdapter = 1
            }
            
            return cell
        }
        else{
            guard let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
            cell.lbl.text = topicMentor[indexPath.row]
            cell.lbl.textColor = AppColor
            cell.backView.backgroundColor = YellowColor
            cell.backView.borderColorTypeAdapter = 10
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == timeCollectionView {
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data == indexPath.row
            }
            if index != nil {
                selectedIndex.remove(at: index!)
            }
            else {
                selectedIndex.append(indexPath.row)
            }
            
            timeCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timeCollectionView {
            timeCollectionViewHeightConstraint.constant = timeCollectionView.contentSize.height
            return CGSize(width: timeCollectionView.frame.size.width/3, height: 45)
        }
        else{
            return CGSize(width: mentorCollectionView.frame.size.width/3, height: 63)
        }
    }

}
