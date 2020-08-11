//
//  EditProfileVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgBtn: Button!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTextView: TextView!
    @IBOutlet weak var startingSchoolTxt: UITextField!
    @IBOutlet weak var majorTxt: UITextField!
    @IBOutlet weak var languageTxt: UITextField!
    @IBOutlet weak var astTxt: UITextField!
    @IBOutlet weak var actTxt: UITextField!
    @IBOutlet weak var gpaTxt: UITextField!
    @IBOutlet weak var searchTxt: TextField!
    
    @IBOutlet weak var interestCollectionView: UICollectionView!
    @IBOutlet weak var interestCollectHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    
    var selectedIndex : [Int] = [Int]()
    var InterestArr = [INTERESTARR.INTEREST1, INTERESTARR.INTEREST2, INTERESTARR.INTEREST3, INTERESTARR.INTEREST4, INTERESTARR.INTEREST5, INTERESTARR.INTEREST6, INTERESTARR.INTEREST7, INTERESTARR.INTEREST8, INTERESTARR.INTEREST9, INTERESTARR.INTEREST10, INTERESTARR.INTEREST11, INTERESTARR.INTEREST12, INTERESTARR.INTEREST13, INTERESTARR.INTEREST14, INTERESTARR.INTEREST15]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Edit Profile"
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

    @IBAction func clickToEditImage(_ sender: Any) {
        CameraAttachment.shared.showAttachmentActionSheet(vc: self)
        CameraAttachment.shared.imagePickedBlock = { pic in
            self.profileImgBtn.setImage(pic, for: .normal)
        }
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        
    }
    
    
}


//MARK: - CollectionView Delegate
extension EditProfileVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == interestCollectionView {
            return InterestArr.count
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
            cell.lbl.text = InterestArr[indexPath.row]
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data == indexPath.row
            }
            if index != nil {
                cell.backView.backgroundColor = RedColor
                cell.backView.alpha = 1
            }
            else {
                cell.backView.backgroundColor = WhiteColor.withAlphaComponent(0.20)
            }
            
            cell.cancelBtn.isHidden = true
            interestCollectHeightConstraint.constant = interestCollectionView.contentSize.height
            return cell
        }
        else{
            guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
                return UICollectionViewCell()
            }
            
            cell.lbl.font = UIFont(name: "MADETommySoft", size: 13.0)
            cell.lbl.text = "DAV"
            cell.backView.backgroundColor = RedColor
            cell.backView.borderColorTypeAdapter = 0
            cell.backView.cornerRadius = 5
            
            cell.cancelBtn.isHidden = false
            cell.cancelBtn.addTarget(self, action: #selector(self.clickToDelete), for: .touchUpInside)
            cell.cancelBtn.tag = indexPath.row
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == interestCollectionView {
            let index = selectedIndex.firstIndex { (data) -> Bool in
                data == indexPath.row
            }
            if index != nil {
                selectedIndex.remove(at: index!)
            }
            else {
                selectedIndex.append(indexPath.row)
            }
            
            interestCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == interestCollectionView {
            interestCollectHeightConstraint.constant = interestCollectionView.contentSize.height
            return CGSize(width: interestCollectionView.frame.size.width/3, height: 65)
        }
        else{
            return CGSize(width: schoolCollectionView.frame.size.width/3, height: 45)
        }
    }

    
    @objc func clickToDelete(_ sender : UIButton)  {
        
    }
    
}
