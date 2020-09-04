//
//  AddNewCardVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class AddNewCardVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var cardNumberTxt: UITextField!
    @IBOutlet weak var monthTxt: UITextField!
    @IBOutlet weak var yearTxt: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!
    
    @IBOutlet var successBackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Add New Card"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
      
    //MARK: - configUI
    func configUI() {
        successBackView.isHidden = true
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToMonthSelect(_ sender: Any) {
        
    }
    
    @IBAction func clickToyearSelect(_ sender: Any) {
        
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        successBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: successBackView)
    }
    
    @IBAction func clickToBackSetting(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    deinit {
        log.success("AddNewCardVC Memory deallocated!")/
    }
      
    
    
}
