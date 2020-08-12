//
//  MentorHomeVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import FSCalendar

class MentorHomeVC: UIViewController {

    @IBOutlet weak var bookingTblView: UITableView!
    @IBOutlet weak var bookingTblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var homeCalender: FSCalendar!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var topHeaderDateLbl: UILabel!
    
    @IBOutlet var completeProfileBackView: UIView!
    
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    private var currentPage: Date?
    
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
        headerLbl.text = getDateStringFromDate(date: homeCalender.currentPage, format: "MMMM yyyy")
        topHeaderDateLbl.text = getDateStringFromDate(date: homeCalender.currentPage, format: "MMMM dd/MM/yyyy")
        
        completeProfileBackView.isHidden = false
        displaySubViewtoParentView(self.view, subview: completeProfileBackView)
        
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
    
    @IBAction func clickToNextMonth(_ sender: Any) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: homeCalender.currentPage)
        homeCalender.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func clickToPreviousMonth(_ sender: Any) {
      let nextMonth = Calendar.current.date(byAdding: .month, value: -1, to: homeCalender.currentPage)
      homeCalender.setCurrentPage(nextMonth!, animated: true)
    }
    
    @IBAction func clickToCompleteProfile(_ sender: Any) {
        completeProfileBackView.isHidden = false
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


extension MentorHomeVC : FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        topHeaderDateLbl.text = getDateStringFromDate(date: date, format: "MMMM dd/MM/yyyy")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
        headerLbl.text = getDateStringFromDate(date: calendar.currentPage, format: "MMMM yyyy")
    }
}
