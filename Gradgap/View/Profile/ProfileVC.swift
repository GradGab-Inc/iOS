//
//  ProfileVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ProfileVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var startingYearLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var satLbl: UILabel!
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    
    var subjectArr : [String] = [String]()
    var schoolNameArr : [MajorListDataModel] = [MajorListDataModel]()
    var profileUpadateVM : MenteeDetailViewModel = MenteeDetailViewModel()
    
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
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        
        profileUpadateVM.delegate = self
        profileUpadateVM.getMenteeProfileDetail()
    }
    
    //MARK:- renderEditProfile
    private func renderProfile() {
        if let profileData = AppModel.shared.currentUser.user {
            self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  profileData.image)
            nameLbl.text = "\(profileData.firstName) \(profileData.lastName)"
            emailLbl.text = profileData.email
            bioLbl.text = profileData.bio
            startingYearLbl.text = "\(profileData.anticipateYear)"
            majorLbl.text = profileData.major
            languageLbl.text = profileData.otherLanguage
            satLbl.text = "\(profileData.scoreSAT)"
            
            if profileData.subjects.count != 0 {
                subjectArr = [String]()
                for i in profileData.subjects {
                    subjectArr.append(InterestArr[i - 1])
                }
                interestCollectionView.reloadData()
            }
            
            if profileData.school.count != 0 {
                schoolNameArr = profileData.school
                schoolCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToEditProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToEditPersonalProfile(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "PersonalProfileVC") as! PersonalProfileVC
        vc.isFromProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.success("ProfileVC Memory deallocated!")/
    }
    
}

extension ProfileVC : MenteeDetailDelegate {
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
extension ProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            return subjectArr.count
        }
        else {
            return schoolNameArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == interestCollectionView {
            guard let cell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = subjectArr[indexPath.row]
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else{
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == interestCollectionView {
            return CGSize(width: interestCollectionView.frame.size.width/3, height: 65)
        }
        else{
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 63)
        }
    }

}
