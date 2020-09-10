//
//  PersonalProfileVC.swift
//  Gradgap
//
//  Created by iMac on 08/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class PersonalProfileVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var firstBtn: Button!
    @IBOutlet weak var secondBtn: Button!
    @IBOutlet weak var thirdBtn: Button!
    @IBOutlet weak var forthBtn: Button!
    @IBOutlet weak var fifthBtn: Button!
    @IBOutlet weak var sixthBtn: Button!
    @IBOutlet weak var sevenBtn: Button!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var bottomProgressBackView: UIView!
    @IBOutlet weak var submitBtn: Button!
    @IBOutlet weak var percentLbl: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var questionArr = ["1. I get energy from being with others :","2. I prefer to get information from observing rather than explanation :","3. I make decisions based on logic rather than feeling :","4. I prefer to have a set plan rather than “go with the flow” :"]
    var countArr = ["1 of 4","2 of 4","3 of 4","4 of 4"]
    
    var currentQuestion : Int = 0
    var profileUpadateVM : ProfileUpdateViewModel = ProfileUpdateViewModel()
    var selectedIndex : [Int : Int] = [Int : Int]()
    var isFromProfile : Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Personality Profile"
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        selectQuestion(currentQuestion)
        submitBtn.isHidden = true
        bottomProgressBackView.isHidden = false
        
        progressView.progress = 0.0
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        percentLbl.text = "0%"
        
        if isFromProfile {
            let personality = AppModel.shared.currentUser.user?.personality ?? Personality.init()
            selectedIndex[0] = personality.energyFromBeingWithOthers
            selectedIndex[1] = personality.informationFromOthers
            selectedIndex[2] = personality.decisionOnLogic
            selectedIndex[3] = personality.goWithFlow
            setupSelection(personality.energyFromBeingWithOthers)
        }
        
        profileUpadateVM.delegate = self
    }
    
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: UIButton) {
        if currentQuestion == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            submitBtn.isHidden = true
            bottomProgressBackView.isHidden = false
            currentQuestion = currentQuestion - 1
            selectQuestion(currentQuestion)
//            let prog : Float = currentQuestion == 3 ? 0.50 : 0.25
//            progressView.progress = progressView.progress - prog
            
            setupProgress()
            percentLbl.text = String(Int(progressView.progress * 100)) + "%"
            print(currentQuestion)
            
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data.key == currentQuestion
            }
            if index != nil {
                resetAllBtn()
                setupSelection(selectedIndex[index!].value)
            }
            
        }
    }

    @IBAction func clickToSelectAnswer(_ sender: UIButton) {
        resetAllBtn()
        sender.isSelected = true
        
        print(currentQuestion)
        if currentQuestion == 3 {
            submitBtn.isHidden = false
            bottomProgressBackView.isHidden = true
            
            if let value = selectedIndex[currentQuestion] {
                selectedIndex[currentQuestion] = sender.tag
            }
            else {
                selectedIndex[currentQuestion] = sender.tag
            }
        }
        else {
            if let value = selectedIndex[currentQuestion] {
                selectedIndex[currentQuestion] = sender.tag
            }
            else {
                selectedIndex[currentQuestion] = sender.tag
            }
            print(selectedIndex)
            currentQuestion = currentQuestion + 1
            selectQuestion(currentQuestion)
            progressView.progress = progressView.progress + 0.25
            percentLbl.text = String(Int(progressView.progress * 100)) + "%"
            delay(0.1) {
                self.resetAllBtn()
            }
            
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data.key == currentQuestion
            }
            if index != nil {
                delay(0.2) {
                    self.setupSelection(self.selectedIndex[index!].value)
                }
            }
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        var request : UpdateRequest = UpdateRequest()
        if let value = selectedIndex[0] {
            request.energyFromBeingWithOthers = value
        }
        if let value = selectedIndex[1] {
            request.informationFromOthers = value
        }
        if let value = selectedIndex[2] {
            request.decisionOnLogic = value
        }
        if let value = selectedIndex[3] {
            request.goWithFlow = value
        }
        profileUpadateVM.updateProfile(request: request, imageData: Data(), fileName: "")
    }
    
    func selectQuestion(_ index : Int) {
        numberLbl.text = countArr[index]
        questionLbl.text = questionArr[index]
    }
    
    func resetAllBtn() {
        firstBtn.isSelected = false
        secondBtn.isSelected = false
        thirdBtn.isSelected = false
        forthBtn.isSelected = false
        fifthBtn.isSelected = false
        sixthBtn.isSelected = false
        sevenBtn.isSelected = false
    }
    
    func setupSelection(_ tag : Int) {
        resetAllBtn()
        switch tag {
        case 1:
            firstBtn.isSelected = true
        case 2:
            secondBtn.isSelected = true
        case 3:
            thirdBtn.isSelected = true
        case 4:
            forthBtn.isSelected = true
        case 5:
            fifthBtn.isSelected = true
        case 6:
            sixthBtn.isSelected = true
        case 7:
            sevenBtn.isSelected = true
        default:
            break
        }
    }
    
    func setupProgress() {
        if currentQuestion == 0 {
            progressView.progress = 0.25
        }
        else if currentQuestion == 1 {
            progressView.progress = 0.50
        }
        else if currentQuestion == 2 {
            progressView.progress = 0.75
        }
    }
    
    deinit {
        log.success("PersonalProfileVC Memory deallocated!")/
    }
}


extension PersonalProfileVC : ProfileUpdateSuccessDelegate {
    func didReceivedData(response: LoginResponse) {
        log.success("WORKING_THREAD:->>>>>>> \(Thread.current.threadName)")/
        var userData : UserDataModel = UserDataModel.init()
        userData.accessToken = AppModel.shared.currentUser.accessToken
        userData.user = response.data!.user
        setLoginUserData(userData)
        AppModel.shared.currentUser = getLoginUserData()
        
        
        var isRedirect = false
        for controller in self.navigationController!.viewControllers as Array {
            if AppModel.shared.currentUser.user?.userType == 1 {
                if controller.isKind(of: HomeVC.self) {
                    isRedirect = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_SIDEMENU_DATA), object: nil)
                    break
                }
            }
            else if AppModel.shared.currentUser.user?.userType == 2 {
                if controller.isKind(of: MentorHomeVC.self) {
                    isRedirect = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_SIDEMENU_DATA), object: nil)
                    break
                }
            }
        }
        if !isRedirect {
            if AppModel.shared.currentUser.user?.userType == 1 {
                AppDelegate().sharedDelegate().navigateToMenteeDashBoard()
            }
            else if AppModel.shared.currentUser.user?.userType == 2 {
                AppDelegate().sharedDelegate().navigateToMentorDashBoard()
            }
        }
    }
}
