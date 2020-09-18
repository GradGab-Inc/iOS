//
//  BankDetailVC.swift
//  Gradgap
//
//  Created by iMac on 03/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import Stripe

class BankDetailVC: UploadImageVC {

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
    
    @IBAction func clickToSelectGender(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select Gender", selected: "", strings: ["Male", "Female"]) { [weak self](gender, index, success) in
            if gender != nil {
                self?.genderTxt.text = gender
            }
            self?.view.endEditing(true)
        }
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
            //Add Bank Details
            var param = [String : Any]()
            param["lastDigitsOfAccountNo"] = accountNumber.suffix(4)
            param["accountHolderName"] = holderName
            param["bankName"] = bankName
            param["country"] = country
            param["state"] = state
            param["city"] = city
            param["line1"] = address1
            param["line2"] = address2
            param["postalCode"] = postalCode
            param["gender"] = gender
            param["ssnLastFour"] = ssn
 //           param["newEmail"] = email
            if PLATFORM.isSimulator {
                 param["ip"] = "192.168.0.102"
            } else {
                param["ip"] = getMyIpAddress()
            }
//            param["url"] = "www.abc.com"
            param["routing_number"] = routingNumber
            
            let bankAccount = STPBankAccountParams()
            bankAccount.routingNumber = routingNumber
            bankAccount.accountNumber = accountNumber
            bankAccount.country = country
            bankAccount.currency = "usd"
            bankAccount.accountHolderName = holderName
            bankAccount.accountHolderType = .individual
            STPAPIClient.shared().createToken(withBankAccount: bankAccount) { (token: STPToken?, error) in
                guard let token = token, error == nil else {
                    // Present error to user...
                    //printData("Error in Token Generation")
                    showAlert("Error", message: error!.localizedDescription) {
                        
                    }
                    return
                }
                param["stripeToken"] = token.tokenId
//                self.addBankAccount(params: param)
            }
        }
    }

    //Get ip address
    func getAddress(for network: String) -> String? {
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

    func getMyIpAddress() -> String
    {
        let arrNetwork = ["en0", "pdp_ip0", "ipv4", "ipv6"]
        for temp in arrNetwork {
            if let address = getAddress(for: temp) {
                return address
            }
        }
        return ""
    }
    
    deinit {
        log.success("BankDetailVC Memory deallocated!")/
    }
}
