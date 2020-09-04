//
//  PaymentMethodVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class PaymentMethodVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    
    var methodArr = ["Credit / Debit Card"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
     override func viewWillAppear(_ animated: Bool) {
         navigationBar.headerLbl.text = "Payment Method"
         navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
         navigationBar.filterBtn.isHidden = true
     }
     
     //MARK: - configUI
     func configUI() {
         tblView.register(UINib(nibName: "CustomQuestionTVC", bundle: nil), forCellReuseIdentifier: "CustomQuestionTVC")
     }
     
     //MARK: - Button Click
     @IBAction func clickToBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }

     deinit {
         log.success("TransactionVC Memory deallocated!")/
     }    
}


//MARK: - TableView Delegate
extension PaymentMethodVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methodArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomQuestionTVC", for: indexPath) as? CustomQuestionTVC
            else {
            return UITableViewCell()
        }
        
        cell.answerLbl.text = methodArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "CardListVC") as! CardListVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
