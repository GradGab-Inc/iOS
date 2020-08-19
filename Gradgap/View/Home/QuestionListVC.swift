//
//  QuestionListVC.swift
//  Gradgap
//
//  Created by iMac on 08/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class QuestionListVC: UIViewController, selectedSchoolDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var startingSchoolTxt: UITextField!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var identifyTxt: UITextField!
    @IBOutlet weak var satTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    
    let listVC : SchoolListView = SchoolListView.instanceFromNib() as! SchoolListView
    var profileUpadateVM : ProfileUpdateViewModel = ProfileUpdateViewModel()
    
    var selectedSchoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    var selectedMajor : MajorListDataModel = MajorListDataModel.init()
    var selectedLanguage : MajorListDataModel = MajorListDataModel.init()
    
    var selectImg : UIImage = UIImage()
    var isMentor : Bool = false
    
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
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToSeelctLanguage(_ sender: Any) {
        self.view.endEditing(true)
        displaySubViewtoParentView(self.view, subview: listVC)
        listVC.flag = 2
        listVC.setUp()
        listVC.tblView.reloadData()
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let school = startingSchoolTxt.text , let major = majorTxt.text ,let language = languageTxt.text, let identift = identifyTxt.text, let sat = satTxt.text, let act = actTxt.text, let gpa = gpaTxt.text else {
            return
        }
        if school.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if major.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if language.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if identift.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if sat.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if act.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else if gpa.trimmed.count == 0 {
            displayToast("Please enter stsrting year")
        }
        else {
            var schoolArr : [String] = [String]()
            for item in selectedSchoolListArr {
                schoolArr.append(item.id)
            }
            
            if isMentor {
                let request = UpdateRequest(schools: schoolArr, anticipateYear: Int(school), major: selectedMajor.id, otherLanguage: selectedLanguage.id, scoreSAT: Float(sat), ethnicity: identift, scoreACT: Float(act), GPA: Float(gpa), changeUserType: 2)
                let imageData = sainiCompressImage(image: selectImg ?? UIImage(named: "ic_profile")!)
                profileUpadateVM.updateProfile(request: request, imageData: imageData, fileName: "image")
            }
            else {
                let request = UpdateRequest(schools: schoolArr, anticipateYear: Int(school), major: selectedMajor.id, otherLanguage: selectedLanguage.id, scoreSAT: Float(sat), ethnicity: identift, scoreACT: Float(act), GPA: Float(gpa), changeUserType: 1)
                profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
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
    
    deinit {
        log.success("QuestionListVC Memory deallocated!")/
    }
    
}


extension QuestionListVC : ProfileUpdateSuccessDelegate {
    func didReceivedData(response: LoginResponse) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        setLoginUserData(response.data!.self)
        AppModel.shared.currentUser = getLoginUserData()
        
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "InterestDiscussVC") as! InterestDiscussVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
