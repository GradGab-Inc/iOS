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
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var accountNumberTxt: UITextField!
    @IBOutlet weak var dobTxt: UITextField!
    @IBOutlet weak var routingNumberTxt: UITextField!
    @IBOutlet weak var address1Txt: UITextField!
    @IBOutlet weak var address2Txt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var stateTxt: UITextField!
    @IBOutlet weak var postalCodeTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    @IBOutlet weak var currencyTxt: UITextField!
    @IBOutlet weak var contactNumberTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var ssnTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    
    @IBOutlet weak var doc1ImgView: UIImageView!
    @IBOutlet weak var doc2ImgView: UIImageView!
    
    var frontImage : UIImage = UIImage()
    var backImage : UIImage = UIImage()
    var addBankDetailVM : BankDetailAddViewModel = BankDetailAddViewModel()
    var selectedGender : Int = -1
    var selectedCountry : String = String()
    var birthDate : Date!
    var isFrontImg : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
//        bankNameTxt.text = "ABC"
//        holderNameTxt.text = "Vishal j Buha"
//        firstNameTxt.text = "Vishal"
//        lastNameTxt.text = "Buha"
//        accountNumberTxt.text = "000123456789"//"123456788"
//        address1Txt.text = "47 W 13th St"
//        address2Txt.text = "New York"
//        routingNumberTxt.text = "110000000"//"HDFC0000261"
//        cityTxt.text = "New York"
//        stateTxt.text = "New York"
//        postalCodeTxt.text = "395006"
//        contactNumberTxt.text = "9874563215"
//        emailTxt.text = "buhavishal1@gmail.com"
//        ssnTxt.text = "1234"
        
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
        addBankDetailVM.delegate = self
    }
    
    private func documentPicGesture() {
        doc1ImgView.sainiAddTapGesture {
            self.isFrontImg = true
            self.uploadImage()
        }
        
        doc2ImgView.sainiAddTapGesture {
            self.isFrontImg = false
            self.uploadImage()
        }
    }
    
    override func selectedImage(choosenImage: UIImage) {
        if isFrontImg {
            self.doc1ImgView.image = choosenImage
            self.frontImage = choosenImage
        }
        else {
            self.doc2ImgView.image = choosenImage
            self.backImage = choosenImage
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectGender(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select Gender", selected: "Male", strings: ["Male", "Female"]) { [weak self](gender, index, success) in
            if gender != nil {
                self?.genderTxt.text = gender
                self?.selectedGender = index
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSelectCountry(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select Country", selected: "United States", strings: getCountryList(0)) { [weak self](country, index, success) in
            if country != nil {
                self?.countryTxt.text = country
                self?.selectedCountry = getCountryCode(index)
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSelectCurrency(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select Currency", selected: "USD", strings: getCurrencyList()) { [weak self](currency, index, success) in
            if currency != nil {
                self?.currencyTxt.text = currency
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToDOB(_ sender: Any) {
        self.view.endEditing(true)
        if birthDate == nil
        {
            birthDate = Date()
        }
        let maxDate : Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        DatePickerManager.shared.showPicker(title: "Select Date", selected: birthDate, min: nil, max: maxDate) { (date, cancel) in
            if !cancel && date != nil {
                self.birthDate = date!
                self.dobTxt.text = getDateStringFromDate(date: self.birthDate, format: "dd/MM/yyyy")
            }
        }
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        guard let bankName = bankNameTxt.text, let fname = firstNameTxt.text, let lname = lastNameTxt.text, let holderName = holderNameTxt.text, let accountNumber = accountNumberTxt.text, let dob = dobTxt.text, let routingNumber = routingNumberTxt.text ,let address1 = address1Txt.text, let address2 = address2Txt.text, let city = cityTxt.text, let state = stateTxt.text, let postalCode = postalCodeTxt.text, let country = countryTxt.text, let contact = contactNumberTxt.text, let email = emailTxt.text, let ssn = ssnTxt.text, let gender = genderTxt.text, let currency = currencyTxt.text else {
            return
        }
        if bankName.trimmed.count == 0 {
            displayToast("Please enter your bank name")
        }
        else if holderName.trimmed.count == 0 {
            displayToast("Please enter your account holder name")
        }
        else if fname.trimmed.count == 0 {
            displayToast("Please enter your first name")
        }
        else if lname.trimmed.count == 0 {
            displayToast("Please enter your last name")
        }
        else if accountNumber.trimmed.count == 0 {
            displayToast("Please enter your account number")
        }
        else if dob.trimmed.count == 0 {
            displayToast("Please select your date of birth")
        }
        else if routingNumber.trimmed.count == 0 {
            displayToast("Please enter your account routing number")
        }
        else if address1.trimmed.count == 0 {
            displayToast("Please enter your address line1")
        }
        else if address2.trimmed.count == 0 {
            displayToast("Please enter your address line2")
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
        else if country.trimmed.count == 0 || selectedCountry == "" {
            displayToast("Please select your country")
        }
        else if contact.trimmed.count == 0 {
            displayToast("Please enter your contact number")
        }
        else if currency.trimmed.count == 0 {
            displayToast("Please select your currency")
        }
        else if email.trimmed.count == 0 {
            displayToast("Please enter your email")
        }
        else if ssn.trimmed.count == 0 {
            displayToast("Please enter your ssn")
        }
//        else if gender.trimmed.count == 0 || selectedGender == -1 {
//            displayToast("Please enter your gender")
//        }
        else if frontImage.size.height == 0 {
            displayToast("Please select document front image")
        }
        else if backImage.size.height == 0 {
            displayToast("Please select document back image")
        }
        else {
            //Add Bank Details
            let bankAccount = STPBankAccountParams()
            bankAccount.routingNumber = routingNumber
            bankAccount.accountNumber = accountNumber
            bankAccount.country = selectedCountry
            bankAccount.currency = currencyTxt.text?.trimmed
            bankAccount.accountHolderName = holderName
            bankAccount.accountHolderType = .individual
            STPAPIClient.shared().createToken(withBankAccount: bankAccount) { (token: STPToken?, error) in
                guard let token = token, error == nil else {
                    showAlert("Error", message: error!.localizedDescription) {
                        
                    }
                    return
                }
                
                let request = AddBankRequest(lastDigitsOfAccountNo: String(accountNumber.suffix(4)), accountHolderName: holderName, bankName: bankName, city: city, country: self.selectedCountry, line1: address1, line2: address2, postalCode: postalCode, state: state, ssnLastFour: ssn, gender: gender.lowercased(), ip: PLATFORM.isSimulator ? "192.168.0.102" : self.getMyIpAddress(), stripeToken: token.tokenId,firstName: fname, lastName: lname, phone: contact, day: getDateStringFromDate(date: self.birthDate, format: "dd"), month: getDateStringFromDate(date: self.birthDate, format: "MM"), year: getDateStringFromDate(date: self.birthDate, format: "yyyy"))
                
                let imageData = sainiCompressImage(image: self.frontImage)
                let imageData1 = sainiCompressImage(image: self.backImage)
                self.addBankDetailVM.addBankDetail(request: request, imageData: imageData, imageData1: imageData1)
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


extension BankDetailVC : BankDetailAddDelegate {
    func didRecievedBankDetailAddData(response: SuccessModel) {
        displayToast(response.message)
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_BANKLIST_DATA), object: nil)
    }
    
    
}
