//
//  ProfileVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var bioLbl: UILabel!
    @IBOutlet weak var startingYearLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var satLbl: UILabel!
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    
    
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
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")

    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToEditProfile(_ sender: Any) {
        
    }
    
    @IBAction func clickToEditPersonalProfile(_ sender: Any) {
        
    }
    
}


//MARK: - CollectionView Delegate
extension ProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            return 3
        }
        else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == interestCollectionView {
            guard let cell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = "Social Life"
            
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            return cell
        }
        else{
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = "DAV"
            cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == interestCollectionView {
            return CGSize(width: interestCollectionView.frame.size.width/3, height: 65)
        }
        else{
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 63)
        }
    }

}
