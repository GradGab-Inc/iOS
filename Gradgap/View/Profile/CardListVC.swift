//
//  CardListVC.swift
//  Gradgap
//
//  Created by iMac on 02/09/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class CardListVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var cardListVM : CardListViewModel = CardListViewModel()
    var cardSelectVM : CardSelectViewModel = CardSelectViewModel()
    var cardListArr : [CardListDataModel] = [CardListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
     override func viewWillAppear(_ animated: Bool) {
         navigationBar.headerLbl.text = "Credit / Debit Card"
         navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
         navigationBar.filterBtn.isHidden = true
     }
     
     //MARK: - configUI
     func configUI() {
         NotificationCenter.default.addObserver(self, selector: #selector(refreshCardList), name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARDLIST_DATA), object: nil)
        
         tblView.register(UINib(nibName: "CardListTVC", bundle: nil), forCellReuseIdentifier: "CardListTVC")
        
         tblView.reloadData()
         tblViewHeightConstraint.constant = CGFloat((cardListArr.count * 85))
        
         cardListVM.delegate = self
         cardSelectVM.delegate = self
         refreshCardList()
     }
     
    @objc func refreshCardList() {
        cardListVM.getCardList()
    }
    
     //MARK: - Button Click
     @IBAction func clickToBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
     @IBAction func clickToAddCard(_ sender: Any) {
         let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AddNewCardVC") as! AddNewCardVC
         self.navigationController?.pushViewController(vc, animated: true)
     }
    
     deinit {
         log.success("CardListVC Memory deallocated!")/
     }
     
    
}

extension CardListVC : CardListDelegate, CardSelectDelegate {
    func didRecieveCardListResponse(response: CardListResponse) {
        cardListArr = [CardListDataModel]()
        cardListArr = response.data
        tblView.reloadData()
        tblViewHeightConstraint.constant = CGFloat((cardListArr.count * 85))
    }
    
    func didRecieveCardSelectResponse(response: SuccessModel) {
        displayToast(response.message)
        refreshCardList()
    }
    
    func didRecieveCardRemoveResponse(response: SuccessModel) {
        displayToast(response.message)
        refreshCardList()
    }
}

//MARK: - TableView Delegate
extension CardListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardListArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CardListTVC", for: indexPath) as? CardListTVC
            else {
            return UITableViewCell()
        }
        
        let dict : CardListDataModel = cardListArr[indexPath.row]
        cell.cardNumberLbl.text = "********\(dict.lastDigitsOfCard)"
        
        cell.radioBtn.isSelected = dict.defaultCard
        cell.radioBtn.tag = indexPath.row
        cell.radioBtn.addTarget(self, action: #selector(self.clickToSelectCard), for: .touchUpInside)
        
        
        cell.removeCardBtn.tag = indexPath.row
        cell.removeCardBtn.addTarget(self, action: #selector(self.clickToRemoveCard), for: .touchUpInside)
        
        tblViewHeightConstraint.constant = CGFloat((cardListArr.count * 85))
        return cell
    }
        
    @objc func clickToSelectCard(_ sender : UIButton) {
        let dict : CardListDataModel = cardListArr[sender.tag]
        cardSelectVM.cardSelect(request: CardSelectRequest(cardRef: dict.id))
    }
    
    @objc func clickToRemoveCard(_ sender : UIButton) {
        showAlertWithOption("Confirmation", message: "Are you sure you want to remove your card?", btns: ["Cancel","Ok"], completionConfirm: {
            let dict : CardListDataModel = self.self.cardListArr[sender.tag]
            self.cardSelectVM.cardRemove(request: CardSelectRequest(cardRef: dict.id))
        }) {
            
        }
    }
}
