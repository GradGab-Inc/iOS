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
    
    var bankListVM : BankViewDetailViewModel = BankViewDetailViewModel()
    var deleteBankVM : BackAccountDeleteViewModel = BackAccountDeleteViewModel()
    
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
        addAccountBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: addAccountBackView)
        
        bankListVM.delegate = self
        bankListVM.getBankDetail()
        
        deleteBankVM.delegate = self
        
        accountNumberLbl.text = ""
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDelete(_ sender: Any) {
        deleteBankVM.deleteBankAccount()
    }
    
    @IBAction func clickToEdit(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "BankDetailVC") as! BankDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToAddBankAccount(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "BankDetailVC") as! BankDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToRemoveBankView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        log.success("BankListVC Memory deallocated!")/
    }
    
}

extension BankListVC : BankViewDetailDelegate, BackAccountDeleteDelegate {
    func didRecievedBankViewDetailData(response: AboutResponse) {
        addAccountBackView.isHidden = true
        
    }
    
    func didRecievedBackAccountDeleteData(response: SuccessModel) {
        addAccountBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: addAccountBackView)
    }

}

