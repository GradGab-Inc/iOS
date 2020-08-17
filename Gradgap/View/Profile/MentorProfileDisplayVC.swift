//
//  MentorProfileDisplayVC.swift
//  Gradgap
//
//  Created by iMac on 13/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class MentorProfileDisplayVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var graduateYearLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var satLbl: UILabel!
    @IBOutlet weak var collegePathLbl: UILabel!
    
    @IBOutlet weak var subjectCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var enrollCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Profile"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        
    }
    
    //MARK: - configUI
    func configUI() {
        subjectCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        enrollCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToEditProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorProfileEditVC") as! MentorProfileEditVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToEditPersonalProfile(_ sender: Any) {
        
    }
    
    deinit {
        log.success("MentorProfileDisplayVC Memory deallocated!")/
    }
    
}


//MARK: - CollectionView Delegate
extension MentorProfileDisplayVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subjectCollectionView {
            return 3
        }
        else if collectionView == schoolCollectionView {
            return 3
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == subjectCollectionView {
            guard let cell = subjectCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = "Social Life"
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else if collectionView == schoolCollectionView {
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = "Social Life"
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = true
            return cell
        }
        else {
            guard let cell = enrollCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.text = ""
            cell.backView.backgroundColor = ClearColor
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 0
            cell.imgView.image = UIImage.init(named: "student-id-card-500x500-2")
            
            cell.cancelBtn.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == subjectCollectionView {
            return CGSize(width: subjectCollectionView.frame.size.width/3, height: 65)
        }
        else if collectionView == schoolCollectionView {
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 45)
        }
        else {
            return CGSize(width: enrollCollectionView.frame.size.width/2.3, height: 90)
        }
    }

}
