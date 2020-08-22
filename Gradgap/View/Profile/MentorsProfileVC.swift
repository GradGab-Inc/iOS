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
    @IBOutlet weak var favoriteBtn: Button!
    
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mentorCollectionView: UICollectionView!
    
    var selectedDate : Date = Date()
    var selectedIndex : Int = -1
    var topicMentor = ["Social Life","Academics","Applying with Low Test Score"]
    var mentorDetailVM : MentorDetailViewModel = MentorDetailViewModel()
    var mentorDetail : MentorData = MentorData.init()
    
    var addToFavoriteVM : SetFavoriteViewModel = SetFavoriteViewModel()
    
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
        
        self.dateBtn.setTitle(getDateStringFromDate(date: self.selectedDate, format: "MMMM dd, yyyy"), for: .normal)
        dataSetup()
        
        addToFavoriteVM.delegate = self
        mentorDetailVM.delegate = self
        getMentorDetailServiceCall(true)
    }
    
    func getMentorDetailServiceCall(_ isLoader : Bool) {
        let request : MentorDetailRequest = MentorDetailRequest(callType: selectedType, userId: selectedUserId, dateTime: getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd"), callTime: selectedCallTime)
        mentorDetailVM.getMentorDetail(request: request, isLoader: isLoader)
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        if mentorDetail.isFavourite {
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: selectedUserId, status: false))
        }
        else{
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: selectedUserId, status: true))
        }
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
                self.getMentorDetailServiceCall(true)
            }
        }
    }
    
    @IBAction func clickToBookMentor(_ sender: Any) {
        if selectedIndex != -1 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ConfirmBookingVC") as! ConfirmBookingVC
            vc.mentorDetail  = mentorDetail
            vc.selectedType = selectedType
            vc.selectedCallTime = selectedCallTime
            vc.selectedDate = selectedDate
            vc.selectedTimeSlot = timeDataArr[selectedIndex]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            displayToast("Please select time slot")
        }
        
    }

    deinit {
        log.success("MentorsProfileVC Memory deallocated!")/
    }
    
}


extension MentorsProfileVC : MentorDetailDelegate, SetFavoriteDelegate {
    func didRecieveSetFavoriteResponse(response: SuccessModel) {
        getMentorDetailServiceCall(false)
    }
    
    func didRecieveMentorDetailResponse(response: MentorDetailModel) {
        mentorDetail = response.data ?? MentorData.init()
        dataSetup()
    }
    
    func dataSetup() {
        profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString: mentorDetail.image)
        nameLbl.text = "\(mentorDetail.firstName) \(mentorDetail.lastName)"
        collegeNameLbl.text = mentorDetail.school.first?.name ?? ""
        courceNameLbl.text = mentorDetail.major
        bioLbl.text = mentorDetail.bio
        rateLbl.text = "\(mentorDetail.averageRating)"
        ratingView.rating = Double(mentorDetail.averageRating)
        
        if mentorDetail.availableTimings.count != 0 {
            noDataLbl.isHidden = true
            timeDataArr = mentorDetail.availableTimings
            timeCollectionView.reloadData()
            timeCollectionViewHeightConstraint.constant = timeCollectionView.contentSize.height
        }
        else {
            timeCollectionViewHeightConstraint.constant = 80
            timeDataArr = [Int]()
            timeCollectionView.reloadData()
            noDataLbl.isHidden = false
        }
        
        if mentorDetail.subjects.count != 0 {
            subjectArr = [String]()
            for i in mentorDetail.subjects {
                subjectArr.append(InterestArr[i - 1])
            }
            mentorCollectionView.reloadData()
        }
        else {
            subjectArr = [String]()
            mentorCollectionView.reloadData()
        }
        
        favoriteBtn.isSelected = mentorDetail.isFavourite
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
            
            let str : Int = timeDataArr[indexPath.row]
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
            
            let timeZone = timeZoneOffsetInMinutes()
            let time = minutesToHoursMinutes(minutes: str + timeZone)
            
            cell.lbl.text = getHourStringFromHoursString(strDate: "\(time.hours):\(time.leftMinutes)", formate: "hh:mm a")
            
            if selectedIndex == indexPath.row {
                cell.backView.backgroundColor = LightBlueColor
                cell.backView.borderColorTypeAdapter = 7
            }
            else {
                cell.backView.backgroundColor = AppColor
                cell.backView.borderColorTypeAdapter = 1
            }
            
            cell.cancelBtn.isHidden = true
            timeCollectionViewHeightConstraint.constant = timeCollectionView.contentSize.height
            return cell
        }
        else{
            guard let cell = mentorCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
            cell.lbl.text = subjectArr[indexPath.row]
            cell.lbl.textColor = AppColor
            cell.backView.backgroundColor = YellowColor
            cell.backView.borderColorTypeAdapter = 10
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == timeCollectionView {
//            let index = selectedIndex.firstIndex { (data) -> Bool in
//                data == indexPath.row
//            }
//            if index != nil {
//                selectedIndex.remove(at: index!)
//            }
//            else {
//                selectedIndex.append(indexPath.row)
//            }
            selectedIndex = indexPath.row
            timeCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timeCollectionView {
            return CGSize(width: timeCollectionView.frame.size.width/3, height: 45)
        }
        else{
            return CGSize(width: mentorCollectionView.frame.size.width/3, height: 63)
        }
    }

}
