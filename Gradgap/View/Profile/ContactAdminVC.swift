//
//  ContactAdminVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ContactAdminVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet var completedBackView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Contact Admin"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        completedBackView.isHidden = true
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        completedBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: completedBackView)
    }
    
    @IBAction func clickToOk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    deinit {
        log.success("ContactAdminVC Memory deallocated!")/
    }
    
}
