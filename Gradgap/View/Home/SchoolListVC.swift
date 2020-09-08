//
//  SchoolListVC.swift
//  Gradgap
//
//  Created by iMac on 06/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils
import MessageUI

class SchoolListVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var schoolCollectionView: UICollectionView!
    @IBOutlet weak var schoolCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var schoolListBackView: UIView!
    @IBOutlet weak var selectedSchoolBackView: UIView!
    @IBOutlet weak var interetedLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    var selectImg : UIImage = UIImage()
    var isMentor : Bool = false
    var dataModel : MajorListModel = MajorListModel()
    var schoolListVM : SchoolSearchListViewModel = SchoolSearchListViewModel()
    var schoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    var selectedSchoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    var schoolCurrentPage : Int = 1
    let mc: MFMailComposeViewController = MFMailComposeViewController()
    
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
      
        let attributedString = NSMutableAttributedString.init(string: "don't see a school you are interested in? Let us know")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
            NSRange.init(location: 0, length: attributedString.length));
        interetedLbl.attributedText = attributedString
        interetedLbl.sainiAddTapGesture {
            let url = "mailto:hello@gradgab.com?subject=Graagap&body=Bookchat".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            openUrlInSafari(strUrl: url!)
        }
        
        schoolListVM.delegate = self
        
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
        
        searchTxt.delegate = self
        deisgnSetup()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
        
        if searchTxt.text?.trimmed != "" {
            schoolCurrentPage = 1
            serviceCallSchool()
        }
        else {
            schoolListBackView.isHidden = true
            selectedSchoolBackView.isHidden = false
            schoolListArr = [MajorListDataModel]()
            self.tblView.reloadData()
        }
    }
    
    func serviceCallSchool() {
        let request = SchoolSearchRequest(text: searchTxt.text ?? "", page: schoolCurrentPage)
        schoolListVM.schoolSearchList(request: request)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        schoolListBackView.isHidden = false
        selectedSchoolBackView.isHidden = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("ok")
        return true
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

    func deisgnSetup() {
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 13.0), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "MADETommySoft", size: 13.0), NSAttributedString.Key.foregroundColor : UIColor.red]
        
        let attributedString1 = NSMutableAttributedString(string: "We are adding mentors from new schools daily. ", attributes: attrs1 as [NSAttributedString.Key : Any])
        let attributedString2 = NSMutableAttributedString(string:"let us know ", attributes: attrs2 as [NSAttributedString.Key : Any])
        let attributedString3 = NSMutableAttributedString(string: "if you don't see a school you're interested in.", attributes: attrs1 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        dataLbl.attributedText = attributedString1
        
        dataLbl.isUserInteractionEnabled = true
        dataLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let text = "We are adding mentors from new schools daily. let us know if you don't see a school you're interested in."
        let letUsKnow = (text as NSString).range(of: "let us know ")

        if gesture.didTapAttributedTextInLabel(label: dataLbl, inRange: letUsKnow) {
            setupMail()
        } else {
            print("Tapped none")
        }
    }
    
    deinit {
        log.success("SchoolListVC Memory deallocated!")/
    }
    
}

extension SchoolListVC : SchoolSearchListSuccessDelegate {
    func didReceivedData(response: MajorListModel) {
        dataModel = response
        if schoolCurrentPage == 1 {
            schoolListArr = [MajorListDataModel]()
        }
        for item in response.data {
            schoolListArr.append(item)
        }
        tblView.reloadData()
    }
}

extension SchoolListVC : MFMailComposeViewControllerDelegate {
    func setupMail() {
//        let url = "mailto:hello@gradgab.com?subject=GradGab&body=Bookchat".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        openUrlInSafari(strUrl: url!)
        
        if MFMailComposeViewController.canSendMail() {
            // present
        }
        else {
            let emailTitle = "Feedback"
            let messageBody = ""
            let toRecipents = ["hello@gradgab.com"]
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipents)
            
//            if MFMessageComposeViewController.canSendText() {
                UIApplication.topViewController()?.present(mc, animated: true, completion: nil)
//            }
            
        }
         
    }
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error.localizedDescription)")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
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
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if schoolListArr.count - 2 == indexPath.row {
            if dataModel.hasMore {
                schoolCurrentPage = schoolCurrentPage + 1
                serviceCallSchool()
            }
        }
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
