//
//  MentorProfileEditVC.swift
//  Gradgap
//
//  Created by iMac on 13/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MentorProfileEditVC: UIViewController, selectedSchoolDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTextView: TextView!
    @IBOutlet weak var graduateTxt: UITextField!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var satTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    @IBOutlet weak var collegePathTxt: UITextField!
    @IBOutlet weak var searchTxt: TextField!
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var enrollCollectionView: UICollectionView!
    
    var profileUpadateVM : ProfileUpdateViewModel = ProfileUpdateViewModel()
    let listVC : SchoolListView = SchoolListView.instanceFromNib() as! SchoolListView
    var selectedIndex : [Int] = [Int]()
    var schoolNameArr : [MajorListDataModel] = [MajorListDataModel]()
    var isNewImgUpload : Bool = false
    var profileData : User = User.init()
    var enrollmentArr : [String] = [String]()
    var selectedMajor : MajorListDataModel = MajorListDataModel.init()
    var isMajorChange : Bool = false
    var selectedLanguage : MajorListDataModel = MajorListDataModel.init()
    var isLanguageChange : Bool = false
    var collegePathIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Edit Profile"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        
    }
    
    //MARK: - configUI
    func configUI() {
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        enrollCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        listVC.delegate = self
        profileUpadateVM.delegate = self
        profilPicGesture()
        renderProfile()
    }
    
    private func profilPicGesture(){
        profileImgView.sainiAddTapGesture {
            CameraAttachment.shared.showAttachmentActionSheet(vc: self)
            CameraAttachment.shared.imagePickedBlock = { pic in
                self.profileImgView.image = pic
                self.isNewImgUpload = true
            }
        }
    }
    
    private func renderProfile() {
        profileData = AppModel.shared.currentUser.user ?? User.init()
        self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  profileData.image)
        firstNameTxt.text = profileData.firstName
        lastNameTxt.text = profileData.lastName
        emailTxt.text = profileData.email
        bioTextView.text = profileData.bio
        graduateTxt.text = "\(profileData.anticipateYear)"
        majorTxt.text = profileData.major
        languageTxt.text = profileData.otherLanguage
        satTxt.text = "\(profileData.scoreSAT)"
        actTxt.text = "\(profileData.scoreACT)"
        gpaTxt.text = "\(profileData.gpa)"
        collegePathTxt.text = getCollegePathString(profileData.collegePath)
        collegePathIndex = profileData.collegePath
        
        if profileData.subjects.count != 0 {
            selectedIndex = [Int]()
            for i in profileData.subjects {
                selectedIndex.append(i)
            }
            interestCollectionView.reloadData()
        }
        
        if profileData.school.count != 0 {
            schoolNameArr = profileData.school
            schoolCollectionView.reloadData()
        }
        
        if profileData.enrollmentId != "" {
            enrollmentArr.append(profileData.enrollmentId)
            enrollCollectionView.reloadData()
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectYear(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Year", selected: "2020", strings: graduationYear) { [weak self](school, index, success) in
            if school != nil {
                self?.graduateTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToPlanedMajor(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 1
        listVC.setUp()
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToSelectLanguage(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 2
        listVC.setUp()
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToSelectCollegePath(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Path", selected: "From High School", strings: collegePathArr) { [weak self](school, index, success) in
            if school != nil {
                self?.collegePathTxt.text = school
                self?.collegePathIndex = index
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSearch(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 3
        listVC.setUp()
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToAddMore(_ sender: Any) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
            
            guard let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let school = graduateTxt.text , let major = majorTxt.text ,let language = languageTxt.text, let sat = satTxt.text, let act = actTxt.text, let gpa = gpaTxt.text, let bio = bioTextView.text, let path = collegePathTxt.text else {
                return
            }
            if firstName.trimmed.count == 0 {
                displayToast("Please enter your first name")
            }
            if lastName.trimmed.count == 0 {
                displayToast("Please enter your last name")
            }
            if school.trimmed.count == 0 {
                displayToast("Please select staring year")
            }
            else if major.trimmed.count == 0 {
                displayToast("Please select current major")
            }
            else if language.trimmed.count == 0 {
                displayToast("Please select language")
            }
            else if sat.trimmed.count == 0 {
                displayToast("Please enter test score SAT")
            }
            else if path.trimmed.count == 0 {
                displayToast("Please select college path")
            }
            else if act.trimmed.count == 0 {
                displayToast("Please enter test score ACT")
            }
            else if gpa.trimmed.count == 0 {
                displayToast("Please enter GPA")
            }
            else if schoolNameArr.count == 0 {
                displayToast("Please select school or college")
            }
            else if selectedIndex.count == 0 {
                displayToast("Please select subject")
            }
                
            else {
                var schoolArr : [String] = [String]()
                for item in schoolNameArr {
                    schoolArr.append(item.id)
                }
                
                var request : UpdateRequest = UpdateRequest()
                if isMajorChange {
                    request.major = selectedMajor.id
                }
                if isLanguageChange {
                    request.otherLanguage = selectedLanguage.id
                }
                
                request.schools = schoolArr
                request.anticipateYear = Int(school)
                request.scoreSAT = Float(sat)
                request.scoreACT = Float(act)
                request.GPA = Float(gpa)
                request.subjects = selectedIndex
                request.firstName = firstName
                request.lastName = lastName
                request.bio = bio
                request.collegePath = collegePathIndex
                                
                if isNewImgUpload {
                    let imageData = sainiCompressImage(image: profileImgView.image ?? UIImage(named: "ic_profile")!)
                    profileUpadateVM.updateProfile(request: request, imageData: imageData, fileName: "image")
                }
                else {
                    profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
                }
            }
    }
    
    func getSelectedMajorArray(_ selectedData: MajorListDataModel) {
        majorTxt.text = selectedData.name
        selectedMajor = selectedData
        isMajorChange = true
    }
    
    func getSelectedLanguageArray(_ selectedData: MajorListDataModel) {
        languageTxt.text = selectedData.name
        selectedLanguage = selectedData
        isLanguageChange = true
    }
    
    func getSelectedSchoolArray(_ selectedData: MajorListDataModel) {
        let index = schoolNameArr.firstIndex { (data) -> Bool in
            data.id == selectedData.id
        }
        if index == nil {
            schoolNameArr.append(selectedData)
        }
        schoolCollectionView.reloadData()
    }
    
    deinit {
        log.success("MentorProfileEditVC Memory deallocated!")/
    }
    
}

extension MentorProfileEditVC : ProfileUpdateSuccessDelegate {
    func didReceivedData(response: LoginResponse) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        var userData : UserDataModel = UserDataModel.init()
        userData.accessToken = AppModel.shared.currentUser.accessToken
        userData.user = response.data!.user
        setLoginUserData(userData)
        AppModel.shared.currentUser = getLoginUserData()
        
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - CollectionView Delegate
extension MentorProfileEditVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            return InterestArr.count
        }
        else if collectionView == schoolCollectionView {
            return schoolNameArr.count
        }
        else {
            return enrollmentArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == interestCollectionView {
            guard let cell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = InterestArr[indexPath.row]
            print(indexPath.row)
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data - 1 == indexPath.row
            }
            if index != nil {
                cell.backView.backgroundColor = RedColor
                cell.backView.alpha = 1
            }
            else {
                cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            }
            
            cell.cancelBtn.isHidden = true
            interestCollectHeightConstraint.constant = interestCollectionView.contentSize.height
            return cell
        }
        else if collectionView == schoolCollectionView {
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = schoolNameArr[indexPath.row].shortName
            cell.backView.backgroundColor = RedColor
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = false
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToDelete), for: .touchUpInside)
            cell.cancelBtn.tag = indexPath.row
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
            cell.imgView.image = UIImage.init(named: enrollmentArr[indexPath.row])
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == interestCollectionView {
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data == indexPath.row + 1
            }
            if index != nil {
                selectedIndex.remove(at: index!)
            }
            else {
                selectedIndex.append(indexPath.row + 1)
            }
            print(selectedIndex)
            interestCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == interestCollectionView {
            interestCollectHeightConstraint.constant = interestCollectionView.contentSize.height
            return CGSize(width: interestCollectionView.frame.size.width/3, height: 65)
        }
        else if collectionView == schoolCollectionView {
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 45)
        }
        else {
            return CGSize(width: enrollCollectionView.frame.size.width/2.3, height: 90)
        }
    }
    
    @objc func clickToDelete(_ sender : UIButton) {
        schoolNameArr.remove(at: sender.tag)
        schoolCollectionView.reloadData()
    }
    
}
