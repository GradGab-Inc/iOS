//
//  BookingDetailVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

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
    
    var addToFavoriteVM : SetFavoriteViewModel = SetFavoriteViewModel()
    var bookingDetailVM : BookingDetailViewModel = BookingDetailViewModel()
    var bookingDetail : BookingDetail = BookingDetail.init()
    var type : Int = 0
    var selectedBooking : BookingListDataModel = BookingListDataModel.init()
    
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
        if type == 1 {
            joinCallBtn.isHidden = true
            cancelBookingBtn.isHidden = true
            rebookCallBtn.isHidden = false
        }
        else {
            joinCallBtn.isHidden = false
            cancelBookingBtn.isHidden = false
            rebookCallBtn.isHidden = true
        }
        
        bookingCantCancelBackView.isHidden = true
        cancelBookingBackView.isHidden = true
        
        addToFavoriteVM.delegate = self
        bookingDetailVM.delegate = self
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToViewProfile(_ sender: Any) {
//        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToFavorite(_ sender: UIButton) {
        if bookingDetail.isFavourite {
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: bookingDetail.mentorRef, status: false))
        }
        else{
            addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: bookingDetail.mentorRef, status: true))
        }
    }
    
    @IBAction func clickToJoinCall(_ sender: Any) {
        
    }
    
    @IBAction func clickToCancelBooking(_ sender: Any) {
//        bookingCantCancelBackView.isHidden = false
//        displaySubViewtoParentView(self.view, subview: bookingCantCancelBackView)
        
        cancelBookingBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: cancelBookingBackView)
    }
    
    @IBAction func clickToRebookCall(_ sender: Any) {
        
    }
    
    @IBAction func clickToOk(_ sender: Any) {
        bookingCantCancelBackView.isHidden = true
    }
    
    @IBAction func clickToCancelNo(_ sender: Any) {
        cancelBookingBackView.isHidden = true
    }
    
    @IBAction func clickToCancelYes(_ sender: Any) {
        cancelBookingBackView.isHidden = true
    }
    
    deinit {
        log.success("BookingDetailVC Memory deallocated!")/
    }
    
}


extension BookingDetailVC : BookingDetailDelegate, SetFavoriteDelegate {
    func didRecieveSetFavoriteResponse(response: SuccessModel) {
        bookingDetailVM.getBookingDetail(request: GetBookingDetailRequest(bookingRef: selectedBooking.id))
    }
    
    func didRecieveBookingDetailResponse(response: BookingDetailModel) {
        bookingDetail = response.data ?? BookingDetail.init()
        renderBookingDetail()
    }
    
    func renderBookingDetail() {
        nameLbl.text = bookingDetail.name
        collegeNameLbl.text = bookingDetail.schoolName
        rateLbl.text = "\(bookingDetail.averageRating)"
        ratingView.rating = bookingDetail.averageRating
        dateTimeLbl.text = displayBookingDate(bookingDetail.dateTime, callTime: bookingDetail.callTime)
        durationLbl.text = "\(bookingDetail.callTime) min"
        serviceLbl.text = ""
        paymentLbl.text = "$\(bookingDetail.amount) Paid"

        favoriteBtn.isSelected = bookingDetail.isFavourite
    }
}
