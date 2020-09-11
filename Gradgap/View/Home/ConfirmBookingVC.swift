//
//  ConfirmBookingVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class ConfirmBookingVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var walletBallenceLbl: UILabel!
    @IBOutlet weak var toBePaidLbl: UILabel!
    @IBOutlet weak var additionalTopicTxt: TextView!
    
    @IBOutlet var bookingStatusBackView: UIView!
    @IBOutlet weak var confirmBookingBtn: Button!
    @IBOutlet weak var backToHomeBtn: Button!
    
    var createBookingVM : CreateBookingViewModel = CreateBookingViewModel()
    var mentorDetail : MentorData = MentorData.init()
    var selectedType : Int = 1
    var selectedCallTime : Int = Int()
    var selectedDate : Date = Date()
    var selectedTimeSlot : Int = Int()
    var isFromFavorite : Bool = false
    
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
        bookingStatusBackView.isHidden = true
        createBookingVM.delegate = self
        renderProfile()
        
        if isFromFavorite {
            backToHomeBtn.setTitle("Back to Favourites", for: .normal)
        }
        else {
            backToHomeBtn.setTitle("Back to Home", for: .normal)
        }
    }
    
    func renderProfile()  {
        nameLbl.text = "\(mentorDetail.firstName) \(mentorDetail.lastName)"
        collegeNameLbl.text = mentorDetail.school.first?.name
        priceLbl.text = "$\(mentorDetail.amount)"
        dateLbl.text = getDateStringFromDate(date: selectedDate, format: "dd/MM/yy")
        durationLbl.text = "\(getCallType(selectedType)), Duration \(selectedCallTime) min"
        
        let timeZone = timeZoneOffsetInMinutes()
        let time = minutesToHoursMinutes(minutes: selectedTimeSlot + timeZone)
        let time1 = minutesToHoursMinutes(minutes: selectedTimeSlot + timeZone + selectedCallTime)
        
        timeLbl.text = "\(getHourStringFromHoursString(strDate: "\(time.hours):\(time.leftMinutes)", formate: "hh:mm a")) - \(getHourStringFromHoursString(strDate: "\(time1.hours):\(time1.leftMinutes)", formate: "hh:mm a"))"
        
        subTotalLbl.text = "$\(mentorDetail.amount)"
        walletBalanceLbl.text = "$0"
        toBePaidLbl.text = "$\(mentorDetail.amount)"
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
        let date = getDateStringFromDate(date: selectedDate, format: "YYYY-MM-dd")
        let str = minutesToHoursMinutes(minutes: selectedTimeSlot)
        let finalDate = "\(date) \(str.hours):\(str.leftMinutes)"
        
        let request = CreateBookingRequest(callType: selectedType, dateTime: finalDate, mentorRef: mentorDetail.id, timeSlot: selectedTimeSlot, callTime: selectedCallTime, additionalTopics: additionalTopicTxt.text)

        createBookingVM.createBooking(request: request)
    }
    
    @IBAction func clickToBackToHome(_ sender: Any) {
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
