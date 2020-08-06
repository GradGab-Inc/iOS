//
//  ConversationStarterVC.swift
//  Gradgap
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class ConversationStarterVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    
    private var expandDict = [String : Bool]()
    var headerQueArr = [CONVERSATION_DATA.GENERAL_QUE, CONVERSATION_DATA.ACADEMIC, CONVERSATION_DATA.SOCIAL, CONVERSATION_DATA.CAMPUS]
    
    var generalQueArr = [GENERAL_QUE.QUESTION1, GENERAL_QUE.QUESTION2, GENERAL_QUE.QUESTION3, GENERAL_QUE.QUESTION4]
    var academicQueArr = [ACADEMIC.QUESTION1, ACADEMIC.QUESTION2, ACADEMIC.QUESTION3, ACADEMIC.QUESTION4, ACADEMIC.QUESTION5, ACADEMIC.QUESTION6, ACADEMIC.QUESTION7, ACADEMIC.QUESTION8]
    var socialQuesArr = [SOCIAL.QUESTION1, SOCIAL.QUESTION2, SOCIAL.QUESTION3, SOCIAL.QUESTION4, SOCIAL.QUESTION5, SOCIAL.QUESTION6, SOCIAL.QUESTION7, SOCIAL.QUESTION8]
    var campusQueArr = [CAMPUS.QUESTION1, CAMPUS.QUESTION2, CAMPUS.QUESTION3, CAMPUS.QUESTION4, CAMPUS.QUESTION5, CAMPUS.QUESTION6]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Conversation Starters"
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib.init(nibName: "CustomHeaderTVC", bundle: nil), forCellReuseIdentifier: "CustomHeaderTVC")
        tblView.register(UINib.init(nibName: "CustomQuestionTVC", bundle: nil), forCellReuseIdentifier: "CustomQuestionTVC")
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension ConversationStarterVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerQueArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let value = expandDict[String(section)], value == true {
            if section == 0 {
                return generalQueArr.count
            }
            else if section == 1 {
                return academicQueArr.count
            }
            else if section == 2 {
                return socialQuesArr.count
            }
            else {
                return campusQueArr.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tblView.dequeueReusableCell(withIdentifier: "CustomHeaderTVC") as! CustomHeaderTVC
        
        header.questionLbl.text = headerQueArr[section]
        header.downBtn.tag = section
        header.downBtn.addTarget(self, action: #selector(self.clickToExpandCell), for: .touchUpInside)
        if let value = expandDict[String(section)], value == true {
            header.downBtn.setImage(UIImage.init(named: "ic_minimisearrow"), for: .normal)
        }
        else {
            header.downBtn.setImage(UIImage.init(named: "ic_dropdownarrow"), for: .normal)
        }
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomQuestionTVC", for: indexPath) as? CustomQuestionTVC
            else {
            return UITableViewCell()
        }
 
        if indexPath.section == 0 {
            cell.answerLbl.text = generalQueArr[indexPath.row]
        }
        else if indexPath.section == 1 {
            cell.answerLbl.text = academicQueArr[indexPath.row]
        }
        else if indexPath.section == 2 {
            cell.answerLbl.text = socialQuesArr[indexPath.row]
        }
        else {
            cell.answerLbl.text = campusQueArr[indexPath.row]
        }
        
        cell.bottomBorderView.backgroundColor = ClearColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToExpandCell(_ sender : UIButton) {
        if let value = expandDict[String(sender.tag)] {
            expandDict[String(sender.tag)] = !value
        }
        else {
            expandDict[String(sender.tag)] = true
        }
        
        tblView.reloadData()
    }
    
}
