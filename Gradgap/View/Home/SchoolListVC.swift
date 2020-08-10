//
//  SchoolListVC.swift
//  Gradgap
//
//  Created by iMac on 06/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class SchoolListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var schoolListBackView: UIView!
    @IBOutlet weak var selectedSchoolBackView: UIView!
    @IBOutlet weak var interetedLbl: UILabel!
    
    
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
        tblView.register(UINib.init(nibName: "CustomQuestionTVC", bundle: nil), forCellReuseIdentifier: "CustomQuestionTVC")
        schoolCollectionView.register(UINib(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
        
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
      
        let attributedString = NSMutableAttributedString.init(string: "don't see a school you are interested in? Let us konw")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        interetedLbl.attributedText = attributedString
        
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
        
        if searchTxt.text?.trimmed != "" {
            
        }
        else {
            self.tblView.reloadData()
        }
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        
    }

    
}

//MARK: - TableView Delegate
extension SchoolListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomQuestionTVC", for: indexPath) as? CustomQuestionTVC
            else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        schoolListBackView.isHidden = true
        selectedSchoolBackView.isHidden = false
        schoolCollectionView.reloadData()
    }
    
}


extension SchoolListVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        schoolCollectionViewHeightConstraint.constant = schoolCollectionView.contentSize.height
        return CGSize(width: schoolCollectionView.frame.size.width/3, height: 65)
    }
    
}
