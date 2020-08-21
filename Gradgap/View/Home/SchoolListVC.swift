//
//  SchoolListVC.swift
//  Gradgap
//
//  Created by iMac on 06/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class SchoolListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var schoolListBackView: UIView!
    @IBOutlet weak var selectedSchoolBackView: UIView!
    @IBOutlet weak var interetedLbl: UILabel!
    
    var selectImg : UIImage = UIImage()
    var isMentor : Bool = false
    var schoolListVM : SchoolSearchListViewModel = SchoolSearchListViewModel()
    var schoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    var selectedSchoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    
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
        interetedLbl.sainiAddTapGesture {
            let url = "mailto:buhavishal1@gmail.com?subject=Graagap&body=Bookchat".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            openUrlInSafari(strUrl: url!)
        }
        
        schoolListVM.delegate = self
        
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
        
        if searchTxt.text?.trimmed != "" {
            let request = SchoolSearchRequest(text: searchTxt.text ?? "")
            schoolListVM.schoolSearchList(request: request)
        }
        else {
            schoolListBackView.isHidden = true
            selectedSchoolBackView.isHidden = false
            schoolListArr = [MajorListDataModel]()
            self.tblView.reloadData()
        }
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        if selectedSchoolListArr.count != 0 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "QuestionListVC") as! QuestionListVC
            vc.selectedSchoolListArr = selectedSchoolListArr
            if isMentor {
                vc.isMentor = true
                vc.selectImg = selectImg
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            displayToast("Please select school")
        }
    }

    deinit {
        log.success("SchoolListVC Memory deallocated!")/
    }
    
}

extension SchoolListVC : SchoolSearchListSuccessDelegate {
    func didReceivedData(response: MajorListModel) {
        schoolListArr = [MajorListDataModel]()
        schoolListArr = response.data
        tblView.reloadData()
    }
}


//MARK: - TableView Delegate
extension SchoolListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolListArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomQuestionTVC", for: indexPath) as? CustomQuestionTVC
            else {
            return UITableViewCell()
        }
        
        cell.answerLbl.text = schoolListArr[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMentor {
            selectedSchoolListArr = [MajorListDataModel]()
            selectedSchoolListArr.append(schoolListArr[indexPath.row])
        }
        else {
            let index = selectedSchoolListArr.firstIndex { (data) -> Bool in
                data.id == schoolListArr[indexPath.row].id
            }
            if index == nil {
                selectedSchoolListArr.append(schoolListArr[indexPath.row])
            }
        }

        schoolListBackView.isHidden = true
        selectedSchoolBackView.isHidden = false
        schoolCollectionView.reloadData()
    }
    
}

//MARK: - CollectionView Delegate
extension SchoolListVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedSchoolListArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = schoolCollectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        cell.lbl.text = selectedSchoolListArr[indexPath.row].shortName
        
        cell.cancelBtn.isHidden = true
        schoolCollectionViewHeightConstraint.constant = schoolCollectionView.contentSize.height
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        schoolCollectionViewHeightConstraint.constant = schoolCollectionView.contentSize.height
        return CGSize(width: schoolCollectionView.frame.size.width/3, height: 65)
    }
    
}
