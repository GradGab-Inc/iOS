//
//  OnboardingVC.swift
//  Gradgap
//
//  Created by iMac on 29/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class OnboardingVC: UIViewController {

    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var infoArr = [INFO_TITLE.info1, INFO_TITLE.info2, INFO_TITLE.info3]
    var imgArr = ["ic_onboarding_illustartion_first","ic_onboarding_illustartion_secong","ic_onboarding_illustartion_third"]
    var backColor = [AppColor, LightBlueColor, YellowColor, AppColor]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK: - configUI
    private func configUI() {
        infoCollectionView.register(UINib(nibName: "InfoCVC", bundle: nil), forCellWithReuseIdentifier: "InfoCVC")
        infoCollectionView.register(UINib(nibName: "OnboardingCVC", bundle: nil), forCellWithReuseIdentifier: "OnboardingCVC")
        pageControll.currentPage = 0
        infoCollectionView.reloadData()
    }
    
    //MARK: - Button Click
    @IBAction func clickToSignUp(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToLogin(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension OnboardingVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCVC", for: indexPath) as? OnboardingCVC else {
                return UICollectionViewCell()
            }

            return cell
        }
        else {
            guard let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "InfoCVC", for: indexPath) as? InfoCVC else {
                return UICollectionViewCell()
            }
            
            cell.titleLbl.text = infoArr[indexPath.row - 1]
            cell.imgView.image = UIImage.init(named: imgArr[indexPath.row - 1])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: SCREEN.WIDTH, height: infoCollectionView.frame.size.height)
    }
    
}


extension OnboardingVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.infoCollectionView.contentOffset, size: self.infoCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.infoCollectionView.indexPathForItem(at: visiblePoint) {
            self.pageControll.currentPage = visibleIndexPath.row
            self.view.backgroundColor = backColor[visibleIndexPath.row]
        }
    }
}