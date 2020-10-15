//
//  ConfirmBookingVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

var userReferId : String = String()


class ConfirmBookingVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var useWalletBalanceLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var discountTitleLbl: UILabel!
    @IBOutlet weak var discountPriceLbl: UILabel!
    @IBOutlet weak var toBePaidLbl: UILabel!
    @IBOutlet weak var additionalTopicTxt: TextView!
    
    @IBOutlet var bookingStatusBackView: UIView!
    @IBOutlet weak var confirmBookingBtn: Button!
    @IBOutlet weak var backToHomeBtn: Button!
    
    @IBOutlet weak var applyCouponBackView: UIView!
    @IBOutlet weak var applyDiscountLbl: UILabel!
    @IBOutlet weak var discountBackView: UIView!
    @IBOutlet weak var walletBackView: UIView!
    
    @IBOutlet weak var useWalletBtn: UIButton!
    @IBOutlet weak var applyCouponTxt: TextField!
    
    @IBOutlet weak var addAccountBackView: UIView!
    
    var createBookingVM : CreateBookingViewModel = CreateBookingViewModel()
    var mentorDetail : MentorData = MentorData.init()
    var applyCoupon : CouponListDataResponse = CouponListDataResponse.init()
    var selectedType : Int = 1
    var selectedCallTime : Int = Int()
    var selectedDate : Date = Date()
    var selectedTimeSlot : Int = Int()
    var isFromFavorite : Bool = false
    var isApplyCoupon : Bool = false
    
    var disc : Double = Double()
    var wallet : Int = Int()
    var cardListVM : CardListViewModel = CardListViewModel()
    var cardListArr : [CardListDataModel] = [CardListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Book"
        navigationBar.backBtn.setImage(UIImage.init(named: "ic_close-1"), for: .normal)
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(addCouponData), name: NSNotification.Name.init(NOTIFICATION.GET_COUPON_DATA), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAddBankView), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARDLIST_DATA), object: nil)
        
        bookingStatusBackView.isHidden = true
        addAccountBackView.isHidden = true
        createBookingVM.delegate = self
        renderProfile()
        
        cardListVM.delegate = self
        cardListVM.getCardList()
        
        if isFromFavorite {
            backToHomeBtn.setTitle("Back to Favorites", for: .normal)
        }
        else {
            backToHomeBtn.setTitle("Back to Home", for: .normal)
        }
        discountBackView.isHidden = true
        applyCouponBackView.isHidden = true
        walletBackView.isHidden = true
        applyDiscountLbl.text = "0% Discount"
        
        useWalletBtn.isSelected = false
    }
    
    func renderProfile() {
        nameLbl.text = "\(mentorDetail.firstName) \(mentorDetail.lastName != "" ? "\(mentorDetail.lastName.first!.uppercased())." : "")"
        collegeNameLbl.text = mentorDetail.school.first?.name
        priceLbl.text = "$\(mentorDetail.amount)"
        dateLbl.text = getDateStringFromDate(date: selectedDate, format: "dd/MM/yy")
        durationLbl.text = "\(getCallType(selectedType)), Duration \(selectedCallTime) min"
        useWalletBalanceLbl.text = "\(AppModel.shared.currentUser.user?.walletAmount ?? 0)"
                
        let timeZone = timeZoneOffsetInMinutes()
        let time = minutesToHoursMinutes(minutes: selectedTimeSlot + timeZone)
        let time1 = minutesToHoursMinutes(minutes: selectedTimeSlot + timeZone + selectedCallTime)
        
        timeLbl.text = "\(getHourStringFromHoursString(strDate: "\(time.hours):\(time.leftMinutes)", formate: "hh:mm a")) - \(getHourStringFromHoursString(strDate: "\(time1.hours):\(time1.leftMinutes)", formate: "hh:mm a"))"
        
        subTotalLbl.text = "$\(mentorDetail.amount)"
        walletBalanceLbl.text = "$0"
        discountTitleLbl.text = "Discount(0%)"
        discountPriceLbl.text = "$0"
        toBePaidLbl.text = "$\(mentorDetail.amount)"
    }
    
    @objc func addCouponData(notification : Notification) {
        if let dict : CouponListDataResponse = notification.object as? CouponListDataResponse
        {
            applyCoupon = dict
            isApplyCoupon = true
            applyCouponBackView.isHidden = false
            discountBackView.isHidden = false
            applyDiscountLbl.text = "\(dict.amountOff)% Discount"
            discountTitleLbl.text = "Discount(\(dict.amountOff)%)"
            
            disc = Double(Double((mentorDetail.amount) * (dict.amountOff))/100)
            discountPriceLbl.text = "-$\(disc)"
            
            if useWalletBtn.isSelected {
                if AppModel.shared.currentUser.user?.walletAmount ?? 0 > mentorDetail.amount {
                    wallet = mentorDetail.amount
                }
                else {
                    wallet = AppModel.shared.currentUser.user?.walletAmount ?? 0
                }
            }
            
            let total = Double(mentorDetail.amount) - disc - Double(wallet)
            toBePaidLbl.text = "$\(String(format: "%.02f", total))"
        }
    }
    
    @objc func refreshAddBankView() {
        cardListVM.getCardList()
        addAccountBackView.isHidden = true
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToApplyCoupon(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ApplyCouponVC") as! ApplyCouponVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func clickToConfirmBooking(_ sender: Any) {
        if cardListArr.count == 0 {
            addAccountBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: addAccountBackView)
            return
        }
        var request : CreateBookingRequest = CreateBookingRequest()
        let date = getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")
        let str = minutesToHoursMinutes(minutes: selectedTimeSlot)
        let finalDate = "\(date) \(str.hours):\(str.leftMinutes)"
        
        request.callType = selectedType
        request.dateTime = finalDate
        request.mentorRef = mentorDetail.id
        request.timeSlot = selectedTimeSlot
        request.callTime = selectedCallTime
        request.additionalTopics = additionalTopicTxt.text
        request.dateTimeText = getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")
        
        if userReferId != "" {
            request.referralId = userReferId
        }
        if useWalletBtn.isSelected {
            request.useWalletBalance = true
        }
        if isApplyCoupon {
            request.couponRef = applyCoupon.id
        }
        if applyCouponTxt.text != "" {
            request.coupon = applyCouponTxt.text
        }
        
        createBookingVM.createBooking(request: request)
    }
    
    @IBAction func clickToBackToHome(_ sender: Any) {
        userReferId = ""
        if isFromFavorite {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: FavoriteVC.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
                    break
                }
            }
        }
        else {
            self.navigationController!.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
        }
    }
    
    @IBAction func clickToRemoveCoupon(_ sender: Any) {
        discountBackView.isHidden = true
        applyCouponBackView.isHidden = true
        isApplyCoupon = false
        applyDiscountLbl.text = "0% Discount"
        
        discountTitleLbl.text = "Discount(0%)"
        discountPriceLbl.text = "$0"
        
        if useWalletBtn.isSelected {
            if AppModel.shared.currentUser.user?.walletAmount ?? 0 > mentorDetail.amount {
                wallet = mentorDetail.amount
            }
            else {
                wallet = AppModel.shared.currentUser.user?.walletAmount ?? 0
            }
        }
        
        let total = Double(mentorDetail.amount) - Double(wallet)
        toBePaidLbl.text = "$\(String(format: "%.01f", total))" //"$\(total)"
    }
    
    @IBAction func clickToUseWallet(_ sender: UIButton) {
        if AppModel.shared.currentUser.user?.walletAmount == 0 {
            displayToast("You have not wallet balance")
            return
        }
        
        if isApplyCoupon {
            disc = Double(Double((mentorDetail.amount) * (applyCoupon.amountOff))/100)
            applyDiscountLbl.text = "\(applyCoupon.amountOff)% Discount"
            discountTitleLbl.text = "Discount(\(applyCoupon.amountOff)%)"
            discountPriceLbl.text = "-$\(disc)"
        }
        if AppModel.shared.currentUser.user?.walletAmount ?? 0 > mentorDetail.amount {
            wallet = mentorDetail.amount
        }
        else {
            wallet = AppModel.shared.currentUser.user?.walletAmount ?? 0
        }
        
        if sender.isSelected {
            sender.isSelected = false
            walletBackView.isHidden = true
            
            let total = Double(mentorDetail.amount) - disc
            toBePaidLbl.text = "$\(String(format: "%.01f", total))" //"$\(total)"
        }
        else {
            sender.isSelected = true
            walletBackView.isHidden = false
            walletBalanceLbl.text = "$\(wallet)"
            let total = Double(mentorDetail.amount) - disc - Double(wallet)
            toBePaidLbl.text = "$\(String(format: "%.01f", total))" //"$\(total)"
        }
    }
    
    @IBAction func clickToRemoveAddBankView(_ sender: Any) {
        addAccountBackView.isHidden = true
    }
    
    @IBAction func clickToAddBankAccount(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        log.success("ConfirmBookingVC Memory deallocated!")/
    }
    
}


extension ConfirmBookingVC : CreateBookingDelegate {
    func didRecieveCreateBookingResponse(response: SuccessModel) {
        displayToast(response.message)
        bookingStatusBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: bookingStatusBackView)
    }
}


extension ConfirmBookingVC : CardListDelegate {
    func didRecieveCardListResponse(response: CardListResponse) {
        cardListArr = [CardListDataModel]()
        cardListArr = response.data
    }
}
