//
//  FaqVC.swift
//  Gradgap
//
//  Created by iMac on 14/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class FaqVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    
    private var expandDict = [String : Bool]()
    private var faqVM: FaqViewModel = FaqViewModel()
    private var FaqListData : [FAQList] = [FAQList].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "FAQs"
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib.init(nibName: "CustomHeaderTVC", bundle: nil), forCellReuseIdentifier: "CustomHeaderTVC")
        tblView.register(UINib.init(nibName: "CustomQuestionTVC", bundle: nil), forCellReuseIdentifier: "CustomQuestionTVC")
        
        faqVM.delegate = self
        faqVM.getFaqList()
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        log.success("FaqVC Memory deallocated!")/
    }

}

extension FaqVC : FaqDelegate {
    func didRecievedFaqListData(response: FaqListResponse) {
        FaqListData = response.data ?? [FAQList].init()
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

//MARK: - TableView Delegate
extension FaqVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FaqListData.count
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
        
        header.questionLbl.text = FaqListData[section].question
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
        cell.answerLbl.text = FaqListData[indexPath.section].answer
        cell.bottomBorderView.backgroundColor = ClearColor
        return cell
    }
    
    @objc func clickToExpandCell(_ sender : UIButton) {
        if let value = expandDict[String(sender.tag)] {
            expandDict[String(sender.tag)] = !value
        }
        else {
            expandDict[String(sender.tag)] = true
        }
        DispatchQueue.main.async { [weak self] in
          self?.tblView.reloadData()
        }
    }
    
}
