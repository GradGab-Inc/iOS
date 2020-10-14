//
//  MentorBookingDetailVC.swift
//  Gradgap
//
//  Created by iMac on 12/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MentorBookingDetailVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var joincallBackView: UIView!
    @IBOutlet weak var joinCallBtn: Button!
    
    @IBOutlet weak var confirmRejectBackView: UIView!
    @IBOutlet weak var additionalLbl: UILabel!
    @IBOutlet weak var learnCollectionView: UICollectionView!
    @IBOutlet weak var anticipentLbl: UILabel!
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var scheduledLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!
    
    @IBOutlet weak var cancelBtn: Button!
    
    @IBOutlet var cancelBookingBackView: UIView!
    @IBOutlet var bookingCantCancelBackView: UIView!
    
    
    var type : Int = 0
    var bookingDetailVM : BookingDetailViewModel = BookingDetailViewModel()
    var bookingActionVM : BookingActionViewModel = BookingActionViewModel()
    var bookingDetail : BookingDetail = BookingDetail.init()
    var selectedBooking : BookingListDataModel = BookingListDataModel.init()
    var selectedDate = Date()
    var selectedStartDate = Date()
    var subjectArr : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Booking Request"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        learnCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        
        bookingDetailVM.delegate = self
        bookingActionVM.delegate = self
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
        
        joincallBackView.isHidden = true
        joinCallBtn.isHidden = true
        cancelBtn.isHidden = true
        confirmRejectBackView.isHidden = true
        bookingCantCancelBackView.isHidden = true
        cancelBookingBackView.isHidden = true
    }
        
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToJoinCall(_ sender: Any) {
        JoinRequestService.getVideoCallData(request: VideoCallDataRequest(bookingRef: bookingDetail.id)) { (response) in
            MeetingModule.shared().prepareMeeting(meetingModel: response!, option: .outgoing) { (status) in
                if status {
                    print("Started")
                }
            }
        }
    }
    
    @IBAction func clickToConfirm(_ sender: Any) {
        let request = GetBookingActionRequest(bookingRef: selectedBooking.id, status: BookingStatus.BOOKED)
        bookingActionVM.getBookingAction(request: request)
    }
    
    @IBAction func clickToReject(_ sender: Any) {
        let request = GetBookingActionRequest(bookingRef: selectedBooking.id, status: BookingStatus.REJECT)
        bookingActionVM.getBookingAction(request: request)
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        if getDifferenceFromCurrentTimeInHourInDays(bookingDetail.dateTime) {
            bookingCantCancelBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: bookingCantCancelBackView)
        }
        else {
            cancelBookingBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: cancelBookingBackView)
        }
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
        log.success("MentorBookingDetailVC Memory deallocated!")/
    }
    
}


//MARK: - CollectionView Delegate
extension MentorBookingDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjectArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = learnCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.font = UIFont(name: "MADETommySoft", size: 14.0)
        cell.lbl.text = subjectArr[indexPath.row]
        
        cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        cell.backView.borderColorTypeAdapter = 0
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: learnCollectionView.frame.size.width/3, height: 65)
    }

}


extension MentorBookingDetailVC : BookingDetailDelegate, BookingActionDelegate {
    func didRecieveBookingActionResponse(response: SuccessModel) {
        displayToast(response.message)
        
        if response.code == 424  {
            cancelBookingBackView.isHidden = true
            bookingCantCancelBackView.isHidden = false
            displaySubViewtoParentView(self.view, subview: bookingCantCancelBackView)
        }
        else {
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_MENTOR_HOME_DATA), object: nil)
        }
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
        scheduledLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime)
        durationLbl.text = "\(bookingDetail.callTime) min"
        serviceLbl.text = getCallType(bookingDetail.callType)
        paymentLbl.text = "$\(bookingDetail.amount) Paid"
        additionalLbl.text = bookingDetail.additionalTopics
        anticipentLbl.text = "\(bookingDetail.anticipateYear)"
        
        if bookingDetail.status == BookingStatus.PENDING {
            joincallBackView.isHidden = true
            joinCallBtn.isHidden = true
            cancelBtn.isHidden = true
            confirmRejectBackView.isHidden = false
        }
        else if bookingDetail.status == BookingStatus.BOOKED {
            confirmRejectBackView.isHidden = true
            joincallBackView.isHidden = false
            joinCallBtn.isHidden = false
            cancelBtn.isHidden = false
        }
        else {
            confirmRejectBackView.isHidden = true
            joincallBackView.isHidden = true
            joinCallBtn.isHidden = true
            cancelBtn.isHidden = true
        }
        
        if bookingDetail.subjects.count != 0 {
            subjectArr = [String]()
            for i in bookingDetail.subjects {
                subjectArr.append(InterestArr[i - 1])
            }
            learnCollectionView.reloadData()
        }
        else {
            subjectArr = [String]()
            learnCollectionView.reloadData()
        }
    }
}
