//
//  MentorHomeVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class MentorHomeVC: UIViewController {

    @IBOutlet weak var bookingTblView: UITableView!
    @IBOutlet weak var bookingTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }

    //MARK: - configUI
    func configUI() {
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
    
    @IBAction func clickToViewAll(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingListVC") as! BookingListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


//MARK: - TableView Delegate
extension MentorHomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bookingTblView.dequeueReusableCell(withIdentifier: "HomeBookingTVC", for: indexPath) as? HomeBookingTVC
            else {
            return UITableViewCell()
        }
        cell.bookedBtn.isHidden = true
        cell.joinBtn.isHidden = true
        if indexPath.row == 0 {
            cell.joinBtn.isHidden = false
            cell.joinBtn.tag = indexPath.row
            cell.joinBtn.addTarget(self, action: #selector(self.clickToJoinCall), for: .touchUpInside)
        }
        else {
            cell.bookedBtn.isHidden = false
        }

       return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "BookingDetailVC") as! BookingDetailVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToJoinCall(_ sender : UIButton) {
//        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: JoinCallVC)
//        JoinCallVC.setUp(0)
    }
    
}
