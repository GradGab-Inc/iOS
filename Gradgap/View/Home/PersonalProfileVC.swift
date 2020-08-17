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
    
    var currentQurstion : Int = 0
    
    
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
        selectQuestion(currentQurstion)
        submitBtn.isHidden = true
        bottomProgressBackView.isHidden = false
        progressView.progress = 0.0
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        percentLbl.text = "0%"
    }
    
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: UIButton) {
        if currentQurstion == 0 {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            submitBtn.isHidden = true
            bottomProgressBackView.isHidden = false
            currentQurstion = currentQurstion - 1
            selectQuestion(currentQurstion)
            let prog : Float = currentQurstion == 3 ? 0.50 : 0.25
            progressView.progress = progressView.progress - prog
            percentLbl.text = String(Int(progressView.progress * 100)) + "%"
        }
    }

    @IBAction func clickToSelectAnswer(_ sender: UIButton) {
        firstBtn.isSelected = false
        secondBtn.isSelected = false
        thirdBtn.isSelected = false
        forthBtn.isSelected = false
        fifthBtn.isSelected = false
        sixthBtn.isSelected = false
        sevenBtn.isSelected = false
        
        sender.isSelected = true
        
        print(currentQurstion)
        if currentQurstion == 3 {
            submitBtn.isHidden = false
            bottomProgressBackView.isHidden = true
        }
        else {
            currentQurstion = currentQurstion + 1
            selectQuestion(currentQurstion)
            progressView.progress = progressView.progress + 0.25
            percentLbl.text = String(Int(progressView.progress * 100)) + "%"
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
    }
    
    func selectQuestion(_ index : Int) {
        numberLbl.text = countArr[index]
        questionLbl.text = questionArr[index]
    }
    
    deinit {
        log.success("PersonalProfileVC Memory deallocated!")/
    }
    
}
