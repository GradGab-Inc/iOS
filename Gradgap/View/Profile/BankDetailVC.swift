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
    @IBOutlet weak var bankNameTxt: UITextField!
    @IBOutlet weak var holderNameTxt: UITextField!
    @IBOutlet weak var accountNumberTxt: UITextField!
    @IBOutlet weak var routingNumberTxt: UITextField!
    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var postalCodeTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var ssnTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    @IBOutlet weak var doc1ImgView: UIImageView!
    @IBOutlet weak var doc2ImgView: UIImageView!
    
    
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
        documentPicGesture()
    }
    
    private func documentPicGesture() {
        doc1ImgView.sainiAddTapGesture {
            CameraAttachment.shared.showAttachmentActionSheet(vc: self)
            CameraAttachment.shared.imagePickedBlock = { pic in
                self.doc1ImgView.image = pic
            }
        }
        
        doc2ImgView.sainiAddTapGesture {
            CameraAttachment.shared.showAttachmentActionSheet(vc: self)
            CameraAttachment.shared.imagePickedBlock = { pic in
                self.doc2ImgView.image = pic
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        guard let bankName = bankNameTxt.text, let holderName = holderNameTxt.text, let accountNumber = accountNumberTxt.text , let routingNumber = routingNumberTxt.text ,let address1 = address1Txt.text, let address2 = address2Txt.text, let city = cityTxt.text, let state = stateTxt.text, let postalCode = postalCodeTxt.text, let country = countryTxt.text, let email = emailTxt.text, let ssn = ssnTxt.text, let gender = genderTxt.text else {
            return
        }
        if bankName.trimmed.count == 0 {
            displayToast("Please enter your bank name")
        }
        else if holderName.trimmed.count == 0 {
            displayToast("Please enter your account holder name")
        }
        else if accountNumber.trimmed.count == 0 {
            displayToast("Please enter your account number")
        }
        else if routingNumber.trimmed.count == 0 {
            displayToast("Please enter your account routing number")
        }
        else if address1.trimmed.count == 0 {
            displayToast("Please enter your address line1")
        }
        else if address2.trimmed.count == 0 {
            displayToast("Please enter your address line1")
        }
        else if city.trimmed.count == 0 {
            displayToast("Please enter your city")
        }
        else if state.trimmed.count == 0 {
            displayToast("Please enter your state")
        }
        else if postalCode.trimmed.count == 0 {
            displayToast("Please enter your postal code")
        }
        else if country.trimmed.count == 0 {
            displayToast("Please enter your country")
        }
        else if email.trimmed.count == 0 {
            displayToast("Please enter your email")
        }
        else if ssn.trimmed.count == 0 {
            displayToast("Please enter your ssn")
        }
        else if gender.trimmed.count == 0 {
            displayToast("Please enter your gender")
        }
        else {
            
        }
    }

    deinit {
        log.success("BankDetailVC Memory deallocated!")/
    }
}
