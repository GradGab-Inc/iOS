//
//  InterestDiscussVC.swift
//  Gradgap
//
//  Created by iMac on 08/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class InterestDiscussVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var interestCollectionView: UICollectionView!
    
    var selectedIndex : [Int] = [Int]()
    var InterestArr = [INTERESTARR.INTEREST1, INTERESTARR.INTEREST2, INTERESTARR.INTEREST3, INTERESTARR.INTEREST4, INTERESTARR.INTEREST5, INTERESTARR.INTEREST6, INTERESTARR.INTEREST7, INTERESTARR.INTEREST8, INTERESTARR.INTEREST9, INTERESTARR.INTEREST10, INTERESTARR.INTEREST11, INTERESTARR.INTEREST12, INTERESTARR.INTEREST13, INTERESTARR.INTEREST14, INTERESTARR.INTEREST15]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.isHidden = true
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        interestCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
    }
    
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToSelectAll(_ sender: Any) {
        
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "PersonalProfileVC") as! PersonalProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - CollectionView Delegate
extension InterestDiscussVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InterestArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = interestCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.text = InterestArr[indexPath.row]
        let index = selectedIndex.firstIndex { (data) -> Bool in
            data == indexPath.row
        }
        if index != nil {
            cell.backView.backgroundColor = RedColor
            cell.backView.alpha = 1
        }
        else {
            cell.backView.backgroundColor = colorFromHex(hex: "2B3E68")
        }
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: interestCollectionView.frame.size.width/3, height: 70)
    }
    
}
