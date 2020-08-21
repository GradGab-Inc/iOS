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
    
    var selectedDate : Date = Date()
    var selectedIndex : [Int] = [Int]()
    var topicMentor = ["Social Life","Academics","Applying with Low Test Score"]
    var mentorDetailVM : MentorDetailViewModel = MentorDetailViewModel()
    var menterDetail : MentorData = MentorData.init()
    
    var selectedUserId : String = String()
    var selectedType : Int = 1
    var selectedCallTime : Int = Int()
    
    var timeDataArr : [Int] = [Int]()
    var subjectArr : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Profile"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        
    }
    
    //MARK: - configUI
    func configUI() {
        timeCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        mentorCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        noDataLbl.isHidden = true
        
        mentorDetailVM.delegate = self
        getMentorDetailServiceCall()
    }
    
    func getMentorDetailServiceCall() {
        let request : MentorDetailRequest = MentorDetailRequest(callType: selectedType, userId: selectedUserId, dateTime: getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd"), callTime: selectedCallTime)
        mentorDetailVM.getMentorDetail(request: request)
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
                self.getMentorDetailServiceCall()
            }
        }
    }
    
    @IBAction func clickToBookMentor(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ConfirmBookingVC") as! ConfirmBookingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        log.success("MentorsProfileVC Memory deallocated!")/
    }
    
}


extension MentorsProfileVC : MentorDetailDelegate {
    func didRecieveMentorDetailResponse(response: MentorDetailModel) {
        menterDetail = response.data ?? MentorData.init()
        dataSetup()
    }
    
    func dataSetup() {
        profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString: menterDetail.image)
        nameLbl.text = "\(menterDetail.firstName) \(menterDetail.lastName)"
        collegeNameLbl.text = menterDetail.schoolName.first ?? ""
        courceNameLbl.text = menterDetail.major
        bioLbl.text = menterDetail.bio
        rateLbl.text = "\(menterDetail.averageRating)"
        ratingView.rating = Double(menterDetail.averageRating)
        
        timeDataArr = menterDetail.availableTimings
        timeCollectionView.reloadData()
        timeCollectionViewHeightConstraint.constant = timeCollectionView.contentSize.height
        
        if menterDetail.subjects.count != 0 {
            subjectArr = [String]()
            for i in menterDetail.subjects {
                subjectArr.append(InterestArr[i + 1])
            }
            mentorCollectionView.reloadData()
        }
        
    }
}

//MARK: - CollectionView Delegate
extension MentorsProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timeCollectionView {
            return timeDataArr.count
        }
        else {
            return subjectArr.count
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
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else{
            guard let cell = mentorCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
            cell.lbl.text = topicMentor[indexPath.row]
            cell.lbl.textColor = AppColor
            cell.backView.backgroundColor = YellowColor
            cell.backView.borderColorTypeAdapter = 10
            
            cell.cancelBtn.isHidden = true
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
            timeCollectionViewHeightConstraint.constant = 90
            return CGSize(width: timeCollectionView.frame.size.width/3, height: 45)
        }
        else{
            return CGSize(width: mentorCollectionView.frame.size.width/3, height: 63)
        }
    }

}
