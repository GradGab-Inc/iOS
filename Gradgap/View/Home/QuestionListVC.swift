//
//  QuestionListVC.swift
//  Gradgap
//
//  Created by iMac on 08/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

var isFromSwitchProfile : Bool = false

class QuestionListVC: UploadImageVC, selectedSchoolDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var startingSchoolLbl: UILabel!
    @IBOutlet weak var startingSchoolTxt: UITextField!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var identifyTxt: UITextField!
    @IBOutlet weak var satTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    @IBOutlet weak var currentPathBackView: UIView!
    @IBOutlet weak var collegePathTxt: UITextField!
    
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var profileImgBackView: UIView!
    @IBOutlet weak var bioBackView: UIView!
    @IBOutlet weak var bioTxtView: TextView!
    
    
    let listVC : SchoolListView = SchoolListView.instanceFromNib() as! SchoolListView
    var profileUpadateVM : ProfileUpdateViewModel = ProfileUpdateViewModel()
    
    var selectedSchoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    var selectedMajor : MajorListDataModel = MajorListDataModel.init()
    var selectedLanguage : MajorListDataModel = MajorListDataModel.init()
    
    var selectImg : UIImage = UIImage()
    var selectedProfileImg : UIImage = UIImage()
    var isMentor : Bool = false
    var collegePathIndex : Int = -1
    var ethinityIndex : Int = -1
    var isFromBack : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.isHidden = true
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        listVC.delegate = self
        profileUpadateVM.delegate = self
        
        isFromBack = isFromSwitchProfile
        
        currentPathBackView.isHidden = true
        bioBackView.isHidden = true
        profileImgBackView.isHidden = true
        profilPicGesture()
        if isMentor {
            startingSchoolLbl.text = "What year do you anticipate graduating? *"
            majorLbl.text = "Current Major *"
            currentPathBackView.isHidden = false
            bioBackView.isHidden = false
            profileImgBackView.isHidden = false
            
            if AppModel.shared.currentUser.user?.image != "" {
                self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  AppModel.shared.currentUser.user?.image ?? "")
                selectedProfileImg = profileImgView.image ?? UIImage()
            }
        }
    }
    
    private func profilPicGesture() {
        profileImgView.sainiAddTapGesture {
            self.uploadImage()
        }
    }
    
    override func selectedImage(choosenImage: UIImage) {
        self.profileImgView.image = choosenImage
        selectedProfileImg = choosenImage
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectStartingSchool(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Year", selected: "2020", strings: graduationYear) { [weak self](school, index, success) in
            if school != nil {
                self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToPlanedMajor(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 1
        listVC.setUp()
        DispatchQueue.main.async { [weak self] in
          self?.listVC.tblView.reloadData()
        }
        
    }
    
    @IBAction func clickToSeelctLanguage(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 2
        listVC.setUp()
        DispatchQueue.main.async { [weak self] in
          self?.listVC.tblView.reloadData()
        }
    }
    
    @IBAction func clickToCollegePath(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Path", selected: "From High School", strings: collegePathArr) { [weak self](school, index, success) in
            if school != nil {
                self?.collegePathTxt.text = school
                self?.collegePathIndex = index
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToEthinity(_ sender: Any) {
        self.view.endEditing(true)
        DatePickerManager.shared.showPicker(title: "Select Ethinity", selected: "Default", strings: ethinityArr) { [weak self](school, index, success) in
            if school != nil {
                self?.identifyTxt.text = school
                self?.ethinityIndex = index
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        guard let school = startingSchoolTxt.text , let major = majorTxt.text ,let language = languageTxt.text, let identift = identifyTxt.text, let sat = satTxt.text, let act = actTxt.text, let gpa = gpaTxt.text, let path = collegePathTxt.text, let bio = bioTxtView.text else {
            return
        }
        if isMentor && selectedProfileImg.size.height == 0 {
            displayToast("Please select profile picture")
        }
        else if school.trimmed.count == 0 {
            displayToast("Please enter anticipate year")
        }
        else if major.trimmed.count == 0 {
            displayToast("Please enter major")
        }
//        else if language.trimmed.count == 0 {
//            displayToast("Please enter other language")
//        }
//        else if identift.trimmed.count == 0 {
//            displayToast("Please enter identify")
//        }
//        else if sat.trimmed.count == 0 {
//            displayToast("Please enter test score SAT")
//        }
//        else if act.trimmed.count == 0 {
//            displayToast("Please enter test score ACT")
//        }
//        else if gpa.trimmed.count == 0 {
//            displayToast("Please enter GPA")
//        }
        else if isMentor && (bio.trimmed.count == 0) {
            displayToast("Please enter bio")
        }
        else if isMentor && (path.trimmed.count == 0 || collegePathIndex == -1) {
            displayToast("Please enter college path")
        }
            
        else {
            var schoolArr : [String] = [String]()
            for item in selectedSchoolListArr {
                schoolArr.append(item.id)
            }
            var request : UpdateRequest = UpdateRequest()
            request.schools = schoolArr
            request.anticipateYear = Int(school)
            request.major = selectedMajor.id
            if sat != "" {
                request.scoreSAT = Double(sat)
            }
            if act != "" {
                request.scoreACT = Double(act)
            }
            if gpa != "" {
                request.GPA = Double(gpa)
            }
            if ethinityIndex != -1 {
                request.ethnicity = ethinityIndex
            }
            if language != "" {
                request.otherLanguage = selectedLanguage.id
            }
            
            if isMentor {
                request.completeProfile = true
                request.collegePath = collegePathIndex
                if AppModel.shared.currentUser.user?.userType == 2 {
                    isFromBack = true
                }
                if !isFromBack && AppModel.shared.currentUser.user?.userType != 2 {
                    request.changeUserType = 2
                    request.bio = bio
                    let imageData = sainiCompressImage(image: selectedProfileImg ?? UIImage(named: "ic_profile")!)
                    let imageData1 = sainiCompressImage(image: selectImg)
                    profileUpadateVM.updateProfileWithTwoImage(request: request, imageData: imageData, imageData1: imageData1)
                }
                else {
                    let imageData = sainiCompressImage(image: selectedProfileImg ?? UIImage(named: "ic_profile")!)
                    let imageData1 = sainiCompressImage(image: selectImg)
                    profileUpadateVM.updateProfileWithTwoImage(request: request, imageData: imageData, imageData1: imageData1)
                }
            }
            else {
                if AppModel.shared.currentUser.user?.userType == 1 {
                    isFromBack = true
                }
                if !isFromBack && AppModel.shared.currentUser.user?.userType != 1 {
                    request.completeProfile = true
                    request.changeUserType = 1
                    if userReferId != "" {
                        request.referralId = userReferId
                    }
                    profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
                }
                else {
                    if isFromSwitchProfile {
                        request.completeProfile = true
                    }
                    profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
                }
            }
        }
    }
    
    func getSelectedMajorArray(_ selectedData: MajorListDataModel) {
        majorTxt.text = selectedData.name
        selectedMajor = selectedData
    }
    
    func getSelectedLanguageArray(_ selectedData: MajorListDataModel) {
        languageTxt.text = selectedData.name
        selectedLanguage = selectedData
    }
    
    func getSelectedSchoolArray(_ selectedData: MajorListDataModel) {
        
    }
    
    deinit {
        log.success("QuestionListVC Memory deallocated!")/
    }
    
}


extension QuestionListVC : ProfileUpdateSuccessDelegate {
    func didReceivedData(response: LoginResponse) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        if isFromBack {
            var userData : UserDataModel = UserDataModel.init()
            userData.accessToken = AppModel.shared.currentUser.accessToken
            userData.user = response.data!.user
            setLoginUserData(userData)
            AppModel.shared.currentUser = getLoginUserData()
        }
        else {
            setLoginUserData(response.data!.self)
            AppModel.shared.currentUser = getLoginUserData()
            
            SocketIOManager.sharedInstance.establishConnection()
        }
        isFromBack = true
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "InterestDiscussVC") as! InterestDiscussVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
