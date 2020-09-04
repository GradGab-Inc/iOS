//
//  BankDetailVC.swift
//  Gradgap
//
//  Created by iMac on 03/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class BankDetailVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    
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
        
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        log.success("BankDetailVC Memory deallocated!")/
    }
}
