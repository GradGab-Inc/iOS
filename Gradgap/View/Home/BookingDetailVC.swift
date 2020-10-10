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
    @IBOutlet weak var dateTimeLbl: UILabel!
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
    var joinCallVM : JoinCallViewModel = JoinCallViewModel()
    var bookingDetail : BookingDetail = BookingDetail.init()
    var type : Int = 0
    var selectedBooking : BookingListDataModel = BookingListDataModel.init()
    var selectedDate = Date()
    var selectedStartDate = Date()
    
    var isFromTransaction : Bool = false
    var transactionDetailVM : TransactionDetailViewModel = TransactionDetailViewModel()
    var selectedTransaction : TransactionListDataModel = TransactionListDataModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Booking Details"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBookingDetail), name: NSNotification.Name.init(NOTIFICATION.UPDATE_BOOKING_DETAIL_DATA), object: nil)
        
        joinCallBtn.isHidden = true
        cancelBookingBtn.isHidden = true
        rebookCallBtn.isHidden = true
        
        bookingCantCancelBackView.isHidden = true
        cancelBookingBackView.isHidden = true
        joinCallVM.delegate = self
        
        if isFromTransaction {
            transactionDetailVM.delegate = self
            transactionDetailVM.getTransactionDetail(request: transactionDetailRequest(transactionRef: selectedTransaction.id))
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
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToViewProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
        vc.selectedUserId = bookingDetail.mentorRef
        vc.bookingDetail = bookingDetail
        vc.isFromBookingDetail = true
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
        joinCallVM.getVideoCallData(request: VideoCallDataRequest(bookingRef: bookingDetail.id))
        
 //       joinMeeting(callKitOption: .outgoing, meetingId: "vishAB", name: "Vishal")
        
//        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "VideoCallVC") as! VideoCallVC
//        self.navigationController?.pushViewController(vc, animated: true)
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
        nameLbl.text = "\(bookingDetail.firstName) \(bookingDetail.lastName != "" ? "\(bookingDetail.lastName.first!.uppercased())." : "")"
        collegeNameLbl.text = bookingDetail.schoolName
        rateLbl.text = "\(bookingDetail.averageRating)"
        ratingView.rating = bookingDetail.averageRating
        dateTimeLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime)
        durationLbl.text = "\(bookingDetail.callTime) min"
        serviceLbl.text = getCallType(bookingDetail.callType)
        paymentLbl.text = "$\(bookingDetail.amount) Paid"

        favoriteBtn.isHidden = true
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
        rateLbl.text = "\(bookingDetail.averageRating)"
        ratingView.rating = bookingDetail.averageRating
        dateTimeLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime)
        durationLbl.text = "\(bookingDetail.callTime) min"
        serviceLbl.text = getCallType(bookingDetail.callType)
        paymentLbl.text = "$\(bookingDetail.amount) Paid"

        favoriteBtn.isSelected = bookingDetail.isFavourite
        
        if bookingDetail.status == BookingStatus.BOOKED {
            joinCallBtn.isHidden = false
            cancelBookingBtn.isHidden = false
            rebookCallBtn.isHidden = true
        }
        else if bookingDetail.status == BookingStatus.CANCELLED || bookingDetail.status == BookingStatus.REJECT {
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
