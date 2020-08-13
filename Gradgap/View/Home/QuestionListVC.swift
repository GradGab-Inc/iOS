//
//  QuestionListVC.swift
//  Gradgap
//
//  Created by iMac on 08/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class QuestionListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var startingSchoolTxt: UITextField!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var identifyTxt: UITextField!
    @IBOutlet weak var satTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    
    
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
        
    }
    
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectStartingSchool(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select School", selected: "91", strings: ["ABC","XYZ"]) { [weak self](school, index, success) in
            if school != nil {
                self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToPlanedMajor(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select School", selected: "91", strings: ["ABC","XYZ"]) { [weak self](school, index, success) in
            if school != nil {
                self?.startingSchoolTxt.text = school
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSeelctLanguage(_ sender: Any) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "InterestDiscussVC") as! InterestDiscussVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.success("QuestionListVC Memory deallocated!")/
    }
    
}
