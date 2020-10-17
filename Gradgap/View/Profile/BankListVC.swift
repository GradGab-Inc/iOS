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
    @IBOutlet weak var addAccountPopUpMessageLbl: UILabel!
    
    var bankListVM : BankViewDetailViewModel = BankViewDetailViewModel()
    var deleteBankVM : BackAccountDeleteViewModel = BackAccountDeleteViewModel()
    var bankDetail : BankViewDataModel = BankViewDataModel()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAddBank), name: NSNotification.Name.init(NOTIFICATION.UPDATE_BANKLIST_DATA), object: nil)
        
        addAccountBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: addAccountBackView)
        addAccountPopUpMessageLbl.text = "Your bank account has not been added"
        
        bankListVM.delegate = self
        bankListVM.getBankDetail()
        
        deleteBankVM.delegate = self
        
        accountNumberLbl.text = ""
    }
    
    @objc func refreshAddBank() {
        bankListVM.getBankDetail()
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDelete(_ sender: Any) {
        showAlertWithOption("Confirmation", message: "Are you sure you want to delete bank details?", btns: ["Cancel","Ok"], completionConfirm: {
            self.deleteBankVM.deleteBankAccount()
        }) {
            
        }
    }
    
    @IBAction func clickToEdit(_ sender: Any) {
//        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "BankDetailVC") as! BankDetailVC
//        self.navigationController?.pushViewController(vc, animated: true)
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
    func didRecievedBankViewDetailData(response: BankViewResponse) {
        bankDetail = response.data ?? BankViewDataModel.init()
        addAccountBackView.isHidden = true
        dataSetup()
    }
    
    func didRecievedBackAccountDeleteData(response: SuccessModel) {
        addAccountBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: addAccountBackView)
        addAccountPopUpMessageLbl.text = "Your Bank account has been removed."
        bankDetail = BankViewDataModel.init()
        dataSetup()
    }
    
    func dataSetup() {
        accountNumberLbl.text = "******\(bankDetail.lastDigitsOfAccountNo)"
    }
    
}

