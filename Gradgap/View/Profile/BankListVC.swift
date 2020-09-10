//
//  BankListVC.swift
//  Gradgap
//
//  Created by iMac on 04/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class BankListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var accountNumberLbl: UILabel!
    @IBOutlet var addAccountBackView: UIView!
    
        override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Bank Details"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
      
    //MARK: - configUI
    func configUI() {
        addAccountBackView.isHidden = true
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDelete(_ sender: Any) {
        addAccountBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: addAccountBackView)
    }
    
    @IBAction func clickToEdit(_ sender: Any) {
        
    }

    deinit {
        log.success("BankListVC Memory deallocated!")/
    }
    
}