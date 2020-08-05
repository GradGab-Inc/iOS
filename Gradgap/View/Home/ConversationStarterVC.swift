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
            return 1
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
 //       cell.titleLbl.text = FaqListData[indexPath.section].answer
        
        return cell
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
