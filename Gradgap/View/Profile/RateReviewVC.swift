//
//  RateReviewVC.swift
//  Gradgap
//
//  Created by iMac on 03/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class RateReviewVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var callRateView: FloatRatingView!
    @IBOutlet weak var favoriteBtn: Button!
    @IBOutlet weak var bottomEmailLbl: UILabel!
    @IBOutlet weak var submitBtn: Button!
    
    @IBOutlet weak var likeCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var callCollectionView: UICollectionView!
    
    var arr = ["Yes", "No", "Default"]
    var selectLike : Int = 0
    var selectInterest : Int = 0
    var selectCall : Int = 0
    var isShowRating : Bool = false
    var ratingVM : RatingViewModel = RatingViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Rate & Review"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
      
    //MARK: - configUI
    func configUI() {
        likeCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        callCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        
        ratingVM.delegate = self
        
        if isShowRating {
            favoriteBtn.isHidden = true
            submitBtn.setTitle("Ok", for: .normal)
            callRateView.isUserInteractionEnabled = false
        }
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddFavoites(_ sender: UIButton) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if isShowRating {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            let request = RatingAddRequest(mentorRef: "", bookingRef: "", stars: Int(callRateView.rating), pursueThisSchool: (selectLike + 1), moreInterestedInSchool: (selectInterest + 1), insightful: (selectCall + 1))
            ratingVM.addRatingReview(request: request)
        }
    }
    
    deinit {
        log.success("RateReviewVC Memory deallocated!")/
    }
}


extension RateReviewVC : RatingDelegate {
    func didRecieveRatingAddResponse(response: NotificationResponse) {
        
    }
}


//MARK: - CollectionView Delegate
extension RateReviewVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == likeCollectionView {
            guard let cell = likeCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.text = arr[indexPath.row]
            if selectLike == indexPath.row {
                cell.backView.backgroundColor = RedColor
                cell.backView.alpha = 1
            }
            else {
                cell.backView.backgroundColor = ClearColor//colorFromHex(hex: "2B3E68")
            }
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else if collectionView == interestCollectionView {
            guard let cell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.text = arr[indexPath.row]
            if selectInterest == indexPath.row {
                cell.backView.backgroundColor = RedColor
                cell.backView.alpha = 1
            }
            else {
                cell.backView.backgroundColor = ClearColor//colorFromHex(hex: "2B3E68")
            }
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else {
            guard let cell = callCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.text = arr[indexPath.row]
            if selectCall == indexPath.row {
                cell.backView.backgroundColor = RedColor
                cell.backView.alpha = 1
            }
            else {
                cell.backView.backgroundColor = ClearColor//colorFromHex(hex: "2B3E68")
            }
            
            cell.cancelBtn.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isShowRating {
            return
        }
        if collectionView == likeCollectionView {
            selectLike = indexPath.row
            likeCollectionView.reloadData()
        }
        else if collectionView == interestCollectionView {
            selectInterest = indexPath.row
            interestCollectionView.reloadData()
        }
        else {
            selectCall = indexPath.row
            callCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == likeCollectionView {
            return CGSize(width: likeCollectionView.frame.size.width/3, height: 40)
        }
        else if collectionView == interestCollectionView {
            return CGSize(width: interestCollectionView.frame.size.width/3, height: 40)
        }
        else{
            return CGSize(width: callCollectionView.frame.size.width/3, height: 40)
        }
    }
    
}
