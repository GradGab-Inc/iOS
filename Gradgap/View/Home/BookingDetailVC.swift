//
//  BookingDetailVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import AmazonChimeSDK

class BookingDetailVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var dateTimeHeaderLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var durationTitleLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    @IBOutlet weak var favoriteBtn: Button!
    
    @IBOutlet weak var joinCallBtn: Button!
    @IBOutlet weak var cancelBookingBtn: Button!
    @IBOutlet weak var rebookCallBtn: Button!
    
    @IBOutlet var bookingCantCancelBackView: UIView!
    @IBOutlet var cancelBookingBackView: UIView!
    
    var createBookingVM : CreateBookingViewModel = CreateBookingViewModel()
    var addToFavoriteVM : SetFavoriteViewModel = SetFavoriteViewModel()
    var bookingDetailVM : BookingDetailViewModel = BookingDetailViewModel()
    var bookingActionVM : BookingActionViewModel = BookingActionViewModel()
    var bookingDetail : BookingDetail = BookingDetail.init()
    var type : Int = 0
    var selectedBooking : BookingListDataModel = BookingListDataModel.init()
    var selectedDate = Date()
    var selectedStartDate = Date()
    
    var isFromTransaction : Bool = false
    var transactionDetailVM : TransactionDetailViewModel = TransactionDetailViewModel()
    var selectedTransaction : TransactionListDataModel = TransactionListDataModel.init()
    var isRateViewNavigate : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if isFromTransaction {
            navigationBar.headerLbl.text = "Transaction Details"
        }
        else {
            navigationBar.headerLbl.text = "Booking Details"
        }
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookingDetail), name: NSNotification.Name.init(NOTIFICATION.UPDATE_BOOKING_DETAIL_DATA), object: nil)
       
//        NotificationCenter.default.addObserver(self, selector: #selector(openRateReviewVC), name: NSNotification.Name.init(NOTIFICATION.ADD_RATEREVIEW_DATA), object: nil)
        
        joinCallBtn.isHidden = true
        cancelBookingBtn.isHidden = true
        rebookCallBtn.isHidden = true
        
        bookingCantCancelBackView.isHidden = true
        cancelBookingBackView.isHidden = true
        
        if isFromTransaction {
            navigationBar.headerLbl.text = "Transaction Details"
            transactionDetailVM.delegate = self
            transactionDetailVM.getTransactionDetail(request: transactionDetailRequest(transactionRef: selectedTransaction.id))
            dateTimeHeaderLbl.text = "Date & Time of Transaction"
            durationTitleLbl.text = "Date & Time Slot Booked"
        }
        else {
            createBookingVM.delegate = self
            addToFavoriteVM.delegate = self
            bookingDetailVM.delegate = self
            bookingActionVM.delegate = self
            bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
        }
    }
    
    @objc func refreshBookingDetail() {
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
    }
    
//    @objc func openRateReviewVC() {
//        if !isRateViewNavigate {
//            isRateViewNavigate = true
//            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "RateReviewVC") as! RateReviewVC
//            vc.bookingDetail = bookingDetail
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToViewProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
        vc.selectedUserId = bookingDetail.mentorRef
        vc.bookingDetail = bookingDetail
        vc.isFromBookingDetail = true
        vc.isFromTransaction = isFromTransaction
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        if bookingDetail.isFavourite {
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: bookingDetail.mentorRef, status: false))
        }
        else {
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: bookingDetail.mentorRef, status: true))
        }
    }
    
    @IBAction func clickToJoinCall(_ sender: Any) {
        if SocketIOManager.sharedInstance.socket.status == .disconnected || SocketIOManager.sharedInstance.socket.status == .notConnected {
            SocketIOManager.sharedInstance.establishConnection()
        }
        JoinRequestService.getVideoCallData(request: VideoCallDataRequest(bookingRef: bookingDetail.id)) { (response) in
            bookingDetailForVideo = self.bookingDetail
            self.isRateViewNavigate = false
            MeetingModule.shared().prepareMeeting(meetingModel: response!, option: .outgoing) { (status) in
                if status {
                    print("Started")
                }
            }
        }
    }
    
    @IBAction func clickToCancelBooking(_ sender: Any) {
        if getDifferenceFromCurrentTimeInHourInDays(bookingDetail.dateTime) {
            bookingCantCancelBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: bookingCantCancelBackView)
        }
        else {
            cancelBookingBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: cancelBookingBackView)
        }
    }
    
    @IBAction func clickToRebookCall(_ sender: Any) {
        let request = CreateBookingRequest(callType: bookingDetail.callType, dateTime: bookingDetail.dateTime, mentorRef: bookingDetail.mentorRef, timeSlot: bookingDetail.timeSlot, callTime: bookingDetail.callTime, additionalTopics: bookingDetail.additionalTopics, dateTimeText: getDateStringFromDateString(strDate: bookingDetail.dateTime, formate: "YYYY-MM-dd"))
        createBookingVM.createBooking(request: request)
    }
    
    @IBAction func clickToOk(_ sender: Any) {
        bookingCantCancelBackView.isHidden = true
    }
    
    @IBAction func clickToCancelNo(_ sender: Any) {
        cancelBookingBackView.isHidden = true
    }
    
    @IBAction func clickToCancelYes(_ sender: Any) {
        let request = GetBookingActionRequest(bookingRef: selectedBooking.id, status: BookingStatus.CANCELLED)
        bookingActionVM.getBookingAction(request: request)
    }
    
    deinit {
        log.success("BookingDetailVC Memory deallocated!")/
    }
}

extension BookingDetailVC : CreateBookingDelegate {
    func didRecieveCreateBookingResponse(response: SuccessModel) {
        displayToast(response.message)
        
        cancelBookingBackView.isHidden = true
        bookingCantCancelBackView.isHidden = true
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
    }
}

extension BookingDetailVC : JoinCallDelegate {
    func didRecieveJoinCallResponse(response: MeetingModel) {
        print(response)
        MeetingModule.shared().prepareMeeting(meetingModel: response, option: .outgoing) { (status) in
            if status{
                print("Started")
                bookingDetailForVideo = self.bookingDetail
            }
        }
    }
}

extension BookingDetailVC : TransactionDetailDelegate {
    func didRecieveTransactionDetailResponse(response: BookingDetailModel) {
        if response.data == nil {
            return
        }
        bookingDetail = response.data ?? BookingDetail.init()
        renderDataFromTransaction()
    }
    
    func renderDataFromTransaction() {
        self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  bookingDetail.image)
        nameLbl.text = "\(bookingDetail.firstName) \(bookingDetail.lastName != "" ? "\(bookingDetail.lastName.first!.uppercased())." : "")"
        collegeNameLbl.text = bookingDetail.schoolName
        rateLbl.text = bookingDetail.averageRating == 0.0 ? "\(5.0)" : "\(bookingDetail.averageRating)"
        ratingView.rating = bookingDetail.averageRating == 0.0 ? 5.0 : bookingDetail.averageRating
        dateTimeLbl.text = getDateStringFromDateString(strDate: bookingDetail.transactionTime, formate: "MMMM dd, yyyy, hh:mm a")
        durationLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime) + " (\(bookingDetail.callTime)min)"
        serviceLbl.text = getCallType(bookingDetail.callType)
        paymentLbl.text = "$\(String(format: "%.2f", bookingDetail.amount)) Paid"//"$\(bookingDetail.amount) Paid"
        favoriteBtn.isHidden = true
        joinCallBtn.isHidden = true
        cancelBookingBtn.isHidden = true
        rebookCallBtn.isHidden = true
        
        if bookingDetail.status == BookingStatus.ADMIN_DELETED {
            rebookCallBtn.isHidden = false
        }
    }
}

extension BookingDetailVC : BookingDetailDelegate, SetFavoriteDelegate, BookingActionDelegate {
    func didRecieveBookingActionResponse(response: SuccessModel) {
        displayToast(response.message)
        
        if response.code == 424  {
            cancelBookingBackView.isHidden = true
            bookingCantCancelBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: bookingCantCancelBackView)
        }
        else {
            cancelBookingBackView.isHidden = true
            bookingCantCancelBackView.isHidden = true
            bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTEE_HOME_DATA), object: nil)
    }
    
    func didRecieveSetFavoriteResponse(response: SuccessModel) {
        if bookingDetail.isFavourite {
            displayToast("Mentor removed from favorites successfully")
        }
        else {
            displayToast("Mentor marked as favorite successfully")
        }
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
    }
    
    func didRecieveBookingDetailResponse(response: BookingDetailModel) {
        if response.data == nil {
            return
        }
        bookingDetail = response.data ?? BookingDetail.init()
        renderBookingDetail()
    }
    
    func renderBookingDetail() {
        self.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString:  bookingDetail.image)
        
        let name = bookingDetail.name.components(separatedBy: " ")
        nameLbl.text = "\(bookingDetail.firstName) \(bookingDetail.lastName != "" ? "\(bookingDetail.lastName.first!.uppercased())." : "")"
//        nameLbl.text = "\(name[0]) \(name.count == 2 ? "\(name[1].first!.uppercased())." : "")"
        collegeNameLbl.text = bookingDetail.schoolName
        rateLbl.text = bookingDetail.averageRating == 0.0 ? "\(5.0)" : "\(bookingDetail.averageRating)"
        ratingView.rating = bookingDetail.averageRating == 0.0 ? 5.0 : bookingDetail.averageRating
        dateTimeLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime)
        durationLbl.text = "\(bookingDetail.callTime) min"
        serviceLbl.text = getCallType(bookingDetail.callType)
        paymentLbl.text = "$\(String(format: "%.2f", bookingDetail.amount)) Paid" //"$\(bookingDetail.amount) Paid"

        favoriteBtn.isSelected = bookingDetail.isFavourite
        
        if bookingDetail.status == BookingStatus.BOOKED {
            let startDate = getDateFromDateString(strDate: bookingDetail.dateTime)
            let endDate = getDateFromDateString(strDate: bookingDetail.dateTime).sainiAddMinutes(Double(bookingDetail.callTime))

            if Date() >= startDate && Date() <= endDate {
                joinCallBtn.isHidden = false
            }
            else {
                joinCallBtn.isHidden = true
            }
            cancelBookingBtn.isHidden = false
            rebookCallBtn.isHidden = true
        }
        else if bookingDetail.status == BookingStatus.CANCELLED || bookingDetail.status == BookingStatus.REJECT  || bookingDetail.status == BookingStatus.ADMIN_DELETED {
            joinCallBtn.isHidden = true
            cancelBookingBtn.isHidden = true
            rebookCallBtn.isHidden = false
        }
        else {
            joinCallBtn.isHidden = true
            cancelBookingBtn.isHidden = false
            rebookCallBtn.isHidden = true
        }
    }
}
