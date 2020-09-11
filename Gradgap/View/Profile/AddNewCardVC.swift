//
//  AddNewCardVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import Stripe

class AddNewCardVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var cardNumberTxt: UITextField!
    @IBOutlet weak var monthTxt: UITextField!
    @IBOutlet weak var yearTxt: UITextField!
    @IBOutlet weak var cvvTxt: UITextField!
    @IBOutlet var successBackView: UIView!
    
    var cardAddVM : CardAddViewModel = CardAddViewModel()
    
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
        cardNumberTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        cardAddVM.delegate = self
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToMonthSelect(_ sender: Any) {
        DatePickerManager.shared.showPicker(title: "Select Month", selected: "", strings: monthArr) { [weak self](month, index, success) in
            if month != nil {
                self?.monthTxt.text = month
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToyearSelect(_ sender: Any) {
        if getYearArr().count == 0 {
            return
        }
        DatePickerManager.shared.showPicker(title: "Select Year", selected: "", strings: getYearArr()) { [weak self](year, index, success) in
            if year != nil {
                self?.yearTxt.text = year
            }
            self?.view.endEditing(true)
        }
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        self.view.endEditing(true)
        guard let name = nameTxt.text else { return }
        guard let cardNumber = cardNumberTxt.text else { return }
        guard let month = monthTxt.text else { return }
        guard let year = yearTxt.text else { return }
        guard let cvv = cvvTxt.text else { return }
        
        if name == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your name")
        }
        else if cardNumber == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your card number")
        }
        else if month == DocumentDefaultValues.Empty.string {
            displayToast("Kindly select expiry month")
        }
        else if year == DocumentDefaultValues.Empty.string {
            displayToast("Kindly select expiry year")
        }
        else if cvv == DocumentDefaultValues.Empty.string {
            displayToast("Kindly enter your cvv")
        }
        else {
            showLoader()
            let cardParams = STPCardParams()
            cardParams.name = nameTxt.text
            cardParams.number = sendDetailByRemovingChar((cardNumberTxt.text?.trimmed)!, char:"-")
            cardParams.expMonth = UInt(month)!
            cardParams.expYear = UInt(year)!
            cardParams.cvc = cvv
            
            STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
                removeLoader()
                if error == nil
                {
                    self.cardAddVM.cardAdd(request: AddCardRequest(cardNumber: name, year: Int(year)!, month: Int(month)!, cvv: Int(cvv)!, stripeToken: token!.tokenId))
                }
                else
                {
                    displayToast(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    @IBAction func clickToBackSetting(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField == cardNumberTxt) {
            cardNumberTxt.text = showCardNumberFormattedStr(cardNumberTxt.text!, isRedacted: false)
        }
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "") {
            return true
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if(textField == cardNumberTxt){
            var maxLength:Int = 0
            maxLength = CARD_NUMBER_CHAR + CARD_NUMBER_DASH_CHAR
            let str:String = cardNumberTxt.text!
            return str.count < maxLength
        }
        else if textField == cvvTxt
        {
            return newLength <= 3
        }
        return true
    }
    
    func showCardNumberFormattedStr(_ str:String, isRedacted:Bool = true) -> String {
        let tempStr:String = sendDetailByRemovingChar(sendDetailByRemovingChar(str, char:"-"), char: " ")
        var retStr:String = ""
        for i in 0..<tempStr.count{
            if(i == 4 || i == 8 || i == 12){
                retStr += "-"
            }
            retStr += tempStr[i]
        }
        if(isRedacted){
            var arr:[String] = retStr.components(separatedBy: "-")
            for i in 0..<arr.count{
                if(i == 1 || i == 2){
                    arr[i] = "xxxx"
                }
            }
            retStr = arr.joined(separator: "-")
        }
        return retStr
    }
    
    func sendDetailByRemovingChar(_ str:String, char:String = " ") -> String {
        let regExp :String = char + "\n\t\r"
        return String(str.filter { !(regExp.contains($0))})
    }
    
    deinit {
        log.success("AddNewCardVC Memory deallocated!")/
    }
    
}


extension AddNewCardVC : CardAddDelegate {
    func didRecieveCardAddResponse(response: CardAddResponse) {
        successBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: successBackView)
    }
}
