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
    
    var type : Int = 0
    
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
        
        if type == 1 {
            joinCallBtn.isHidden = true
            cancelBtn.isHidden = true
            confirmRejectBackView.isHidden = false
        }
        else{
            confirmRejectBackView.isHidden = true
            joinCallBtn.isHidden = false
            cancelBtn.isHidden = false
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToJoinCall(_ sender: Any) {
        
    }
    
    @IBAction func clickToConfirm(_ sender: Any) {
        
    }
    
    @IBAction func clickToReject(_ sender: Any) {
        
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        
    }
    
    deinit {
        log.success("MentorBookingDetailVC Memory deallocated!")/
    }
    
}


//MARK: - CollectionView Delegate
extension MentorBookingDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = learnCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.font = UIFont(name: "MADETommySoft", size: 14.0)
        cell.lbl.text = "Social Life"
        
        cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
        cell.backView.borderColorTypeAdapter = 0
        
        cell.cancelBtn.isHidden = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: learnCollectionView.frame.size.width/3, height: 65)
    }

}
