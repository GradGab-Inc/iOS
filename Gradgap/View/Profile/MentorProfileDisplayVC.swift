//
//  MentorProfileDisplayVC.swift
//  Gradgap
//
//  Created by iMac on 13/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MentorProfileDisplayVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var graduateYearLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var satLbl: UILabel!
    @IBOutlet weak var collegePathLbl: UILabel!
    @IBOutlet weak var ethinicityLbl: UILabel!
    @IBOutlet weak var actLbl: UILabel!
    @IBOutlet weak var gpaLbl: UILabel!
    
    @IBOutlet weak var subjectCollectionView: UICollectionView!
    @IBOutlet weak var subjectCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var enrollCollectionView: UICollectionView!
    
    var profileUpadateVM : MenteeDetailViewModel = MenteeDetailViewModel()
    var subjectArr : [String] = [String]()
    var schoolNameArr : [MajorListDataModel] = [MajorListDataModel]()
    var enrollmentArr : [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Profile"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        renderProfile()
    }
    
    //MARK: - configUI
    func configUI() {
        subjectCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        enrollCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        
        profileUpadateVM.delegate = self
        profileUpadateVM.getMenteeProfileDetail()
    }
    
    //MARK:- renderEditProfile
    private func renderProfile() {
        if let profileData = AppModel.shared.currentUser.user {
            self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  profileData.image)
            nameLbl.text = "\(profileData.firstName) \(profileData.lastName != "" ? "\(profileData.lastName.first!.uppercased())." : "")"
            emailLbl.text = profileData.email
            bioLbl.text = profileData.bio
            graduateYearLbl.text = "\(profileData.anticipateYear)"
            majorLbl.text = profileData.major
            languageLbl.text = profileData.otherLanguage
            satLbl.text =  String(format: "%.01f", profileData.scoreSAT) //"\(profileData.scoreSAT)"
            actLbl.text =  String(format: "%.01f", profileData.scoreACT) //"\(profileData.scoreACT)"
            gpaLbl.text =  String(format: "%.01f", profileData.gpa) //"\(profileData.gpa)"
            ethinicityLbl.text = profileData.ethnicity != -1 ? ethinityArr[profileData.ethnicity] : ""
            rateLbl.text = profileData.averageRating == 0.0 ? "5.0" : "\(profileData.averageRating)"
            ratingView.rating = profileData.averageRating == 0.0 ? 5.0 : profileData.averageRating
            collegePathLbl.text = getCollegePathString(profileData.collegePath)
            
            if profileData.subjects.count != 0 {
                subjectArr = [String]()
                for i in profileData.subjects {
                    subjectArr.append(InterestArr[i - 1])
                }
                DispatchQueue.main.async { [weak self] in
                    self?.subjectCollectionView.reloadData()
                }
            }
            
            if profileData.school.count != 0 {
                schoolNameArr = profileData.school
                DispatchQueue.main.async { [weak self] in
                    self?.schoolCollectionView.reloadData()
                }
            }
            
            if profileData.enrollmentId != "" {
                enrollmentArr = [String]()
                enrollmentArr.append(profileData.enrollmentId)
                DispatchQueue.main.async { [weak self] in
                    self?.enrollCollectionView.reloadData()
                }
            }
            else {
                DispatchQueue.main.async { [weak self] in
                    self?.enrollCollectionView.reloadData()
                }
            }
        }
    }
    
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToEditProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorProfileEditVC") as! MentorProfileEditVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToEditPersonalProfile(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "PersonalProfileVC") as! PersonalProfileVC
        vc.isFromProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.success("MentorProfileDisplayVC Memory deallocated!")/
    }
    
}

extension MentorProfileDisplayVC : MenteeDetailDelegate {
    func didRecieveMenteeDetailResponse(response: MenteeDetailModel) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        var userData : UserDataModel = UserDataModel.init()
        userData.accessToken = AppModel.shared.currentUser.accessToken
        userData.user = response.data
        setLoginUserData(userData)
        AppModel.shared.currentUser = getLoginUserData()
        
        renderProfile()
    }
}


//MARK: - CollectionView Delegate
extension MentorProfileDisplayVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subjectCollectionView {
            return subjectArr.count
        }
        else if collectionView == schoolCollectionView {
            return schoolNameArr.count
        }
        else {
            return enrollmentArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subjectCollectionView {
            guard let cell = subjectCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = subjectArr[indexPath.row]
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = true
            subjectCollectionViewHeightConstraint.constant = subjectCollectionView.contentSize.height
            return cell
        }
        else if collectionView == schoolCollectionView {
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = schoolNameArr[indexPath.row].shortName
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else {
            guard let cell = enrollCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.text = ""
            cell.backView.backgroundColor = ClearColor
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 0
            cell.imgView.downloadCachedImage(placeholder: "ic_profile", urlString:  enrollmentArr[indexPath.row])
            cell.cancelBtn.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subjectCollectionView {
            return CGSize(width: subjectCollectionView.frame.size.width/3, height: 65)
        }
        else if collectionView == schoolCollectionView {
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 45)
        }
        else {
            return CGSize(width: enrollCollectionView.frame.size.width/2.3, height: 90)
        }
    }

}
