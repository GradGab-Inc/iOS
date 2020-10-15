//
//  EditProfileVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import MessageUI

class EditProfileVC: UploadImageVC, selectedSchoolDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTextView: TextView!
    @IBOutlet weak var startingSchoolTxt: UITextField!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var astTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    @IBOutlet weak var searchTxt: TextField!
    @IBOutlet weak var identifyTxt: UITextField!
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var profileUpadateVM : ProfileUpdateViewModel = ProfileUpdateViewModel()
    let listVC : SchoolListView = SchoolListView.instanceFromNib() as! SchoolListView
    var selectedIndex : [Int] = [Int]()
    var schoolNameArr : [MajorListDataModel] = [MajorListDataModel]()
    var isNewImgUpload : Bool = false
    var profileData : User = User.init()
    
    var selectedMajor : MajorListDataModel = MajorListDataModel.init()
    var isMajorChange : Bool = false
    var selectedLanguage : MajorListDataModel = MajorListDataModel.init()
    var isLanguageChange : Bool = false
    var ethinityIndex : Int = -1
    
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
        listVC.delegate = self
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        profileUpadateVM.delegate = self
        profilPicGesture()
        renderProfile()
    }
    
    private func profilPicGesture(){
        profileImgView.sainiAddTapGesture {
            self.uploadImage()
//            CameraAttachment.shared.showAttachmentActionSheet(vc: self)
//            CameraAttachment.shared.imagePickedBlock = { pic in
//                self.profileImgView.image = pic
//                self.isNewImgUpload = true
//            }
        }
    }
    
    override func selectedImage(choosenImage: UIImage) {
        self.profileImgView.image = choosenImage
        self.isNewImgUpload = true
    }
    
    private func renderProfile() {
        profileData = AppModel.shared.currentUser.user ?? User.init()
        self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  profileData.image)
        firstNameTxt.text = profileData.firstName
        lastNameTxt.text = profileData.lastName
        emailTxt.text = profileData.email
        bioTextView.text = profileData.bio
        startingSchoolTxt.text = "\(profileData.anticipateYear)"
        majorTxt.text = profileData.major
        languageTxt.text = profileData.otherLanguage
        astTxt.text =  String(format: "%.01f", profileData.scoreSAT) //"\(profileData.scoreSAT)"
        actTxt.text =  String(format: "%.01f", profileData.scoreACT) //"\(profileData.scoreACT)"
        gpaTxt.text =  String(format: "%.01f", profileData.gpa) //"\(profileData.gpa)"
        identifyTxt.text = profileData.ethnicity != -1 ? ethinityArr[profileData.ethnicity] : ""
        ethinityIndex = profileData.ethnicity
        
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
   }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let firstName = firstNameTxt.text, let lastName = lastNameTxt.text, let school = startingSchoolTxt.text , let major = majorTxt.text ,let language = languageTxt.text, let sat = astTxt.text, let act = actTxt.text, let gpa = gpaTxt.text, let bio = bioTextView.text, let identift = identifyTxt.text else {
            return
        }
        if firstName.trimmed.count == 0 {
            displayToast("Please enter your first name")
        }
        else if lastName.trimmed.count == 0 {
            displayToast("Please enter your last name")
        }
        else if school.trimmed.count == 0 {
            displayToast("Please select staring year")
        }
        else if major.trimmed.count == 0 {
            displayToast("Please select planned major")
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
            request.scoreSAT = Double(sat)
            request.scoreACT = Double(act)
            request.GPA = Double(gpa)
            request.subjects = selectedIndex.sorted()
            request.firstName = firstName
            request.lastName = lastName
            request.bio = bio
            
            if ethinityIndex != -1 {
                request.ethnicity = ethinityIndex
            }
             
            if isNewImgUpload {
                let imageData = sainiCompressImage(image: profileImgView.image ?? UIImage(named: "ic_profile")!)
                profileUpadateVM.updateProfile(request: request, imageData: imageData, fileName: "image")
            }
            else {
                profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
            }
        }
    }
    
    @IBAction func clickToSelectYear(_ sender: Any) {
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
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToSelectLanguage(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 2
        listVC.setUp()
        listVC.tblView.reloadData()
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
    
    @IBAction func clickToSearch(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 3
        listVC.setUp()
        listVC.tblView.reloadData()
    }

    @IBAction func clickToDontSee(_ sender: Any) {
        setupMail()
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
        log.success("EditProfileVC Memory deallocated!")/
    }
    
}

extension EditProfileVC : MFMailComposeViewControllerDelegate {
    func setupMail() {
        redirectToEmail()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


extension EditProfileVC : ProfileUpdateSuccessDelegate {
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
extension EditProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            return InterestArr.count
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
        else{
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = schoolNameArr[indexPath.row].shortName
            cell.backView.backgroundColor = RedColor
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.tag = indexPath.row
            cell.cancelBtn.isHidden = false
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToDelete), for: .touchUpInside)
            
            schoolCollectionViewHeightConstraint.constant = schoolCollectionView.contentSize.height
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
        else{
            schoolCollectionViewHeightConstraint.constant = schoolCollectionView.contentSize.height
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 63)
        }
    }
    
    @objc func clickToDelete(_ sender : UIButton)  {
        schoolNameArr.remove(at: sender.tag)
        schoolCollectionView.reloadData()
    }
    
}
