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
    
    @IBOutlet weak var likeCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var callCollectionView: UICollectionView!
    
    var arr = ["Yes", "No", "Default"]
    var selectLike : Int = 0
    var selectInterest : Int = 0
    var selectCall : Int = 0
    
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
    }
      
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddFavoites(_ sender: Any) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
    }
    
    deinit {
        log.success("RateReviewVC Memory deallocated!")/
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
        else {
            guard let cell = callCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
