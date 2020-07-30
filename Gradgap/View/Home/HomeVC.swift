//
//  HomeVC.swift
//  Gradgap
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var homeTblView: UITableView!
    @IBOutlet weak var bookingTblView: UITableView!
    @IBOutlet weak var bookingTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var titleArr = ["Chat","Virtual Tour","Interview Prep"]
    var subTitleArr = ["Video chat with a current student.","Get a live 1 hour campus tour.","45 Min Mock Interview Prep or Mock interview."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - configUI
    func configUI() {
        homeTblView.register(UINib.init(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        bookingTblView.register(UINib(nibName: "HomeBookingTVC", bundle: nil), forCellReuseIdentifier: "HomeBookingTVC")
        noDataLbl.isHidden = true
        
        bookingTblView.reloadData()
        bookingTblViewHeightConstraint.constant = 234
    }
    
    //MARK: - Button Click
    @IBAction func clickToSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.menuContainerViewController.toggleLeftSideMenuCompletion({ })
    }
    
    @IBAction func clickToProfile(_ sender: Any) {
        
    }
    
    @IBAction func clickToViewAll(_ sender: Any) {
        
    }
    
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeTblView {
            return 3
        }
        else{
           return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == homeTblView {
            return 120
        }
        else {
           return 116
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == homeTblView {
            guard let cell = homeTblView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as? HomeTVC
                else {
                return TableViewCell()
            }
            cell.titleLbl.text = titleArr[indexPath.row]
            cell.subLbl.text = subTitleArr[indexPath.row]
            
            return cell
        }
        else{
            guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
                else {
                return TableViewCell()
            }
            cell.bookedBtn.isHidden = true
            cell.joinBtn.isHidden = true
            if indexPath.row == 0 {
                cell.joinBtn.isHidden = false
            }
            else {
                cell.bookedBtn.isHidden = false
            }

           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
