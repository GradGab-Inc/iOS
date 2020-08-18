//
//  SchoolListView.swift
//  Gradgap
//
//  Created by iMac on 18/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import Foundation
import UIKit

protocol selectedSchoolDelegate {
    func getSelectedMajorArray(_ selectedData : MajorListDataModel)
    func getSelectedLanguageArray(_ selectedData : MajorListDataModel)
}



class SchoolListView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    var flag : Int = 1
    var isRegisterd : Bool = false
    var delegate : selectedSchoolDelegate?
    
    var majorListVM : MajorListViewModel = MajorListViewModel()
    var majorListArr : [MajorListDataModel] = [MajorListDataModel]()
    
    var languageListVM : LanguageListViewModel = LanguageListViewModel()
    var languageListArr : [MajorListDataModel] = [MajorListDataModel]()
    
    var listArr : [MajorListDataModel] = [MajorListDataModel]()
    
    class func instanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed("SchoolListView", owner: self, options: nil)![0] as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
        
    }
    
    func setUp() {
        if tblView == nil {
            delay(0) {
                self.setUp()
            }
            return
        }
        
        tblView.register(UINib.init(nibName: "CustomQuestionTVC", bundle: nil), forCellReuseIdentifier: "CustomQuestionTVC")
        listArr = [MajorListDataModel]()
        tblView.reloadData()
        
        
        if flag == 1 {
            majorListVM.delegate = self
            if majorListArr.count == 0 {
                majorListVM.majorList()
            }
            else {
                listArr = majorListArr
                tblView.reloadData()
            }
        }
        else if flag == 2 {
            languageListVM.delegate = self
            if languageListArr.count == 0 {
                languageListVM.languageList()
            }
            else {
                listArr = languageListArr
                tblView.reloadData()
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tblView != nil && !isRegisterd {
            setUp()
            isRegisterd = true
        }
        
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "CustomQuestionTVC", for: indexPath) as? CustomQuestionTVC
            else {
            return UITableViewCell()
        }
        cell.answerLbl.text = listArr[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if flag == 1 {
            delegate?.getSelectedMajorArray(listArr[indexPath.row])
            self.removeFromSuperview()
        }
        else if flag == 2 {
            delegate?.getSelectedLanguageArray(listArr[indexPath.row])
            self.removeFromSuperview()
        }
    }
}

extension SchoolListView : MajorListSuccessDelegate, LanguageListSuccessDelegate {
    func didReceivedMajorData(response: MajorListModel) {
        majorListArr = [MajorListDataModel]()
        majorListArr = response.data
        listArr = response.data
        tblView.reloadData()
    }
    
    func didReceivedLanguageData(response: MajorListModel) {
        languageListArr = [MajorListDataModel]()
        languageListArr = response.data
        listArr = response.data
        tblView.reloadData()
    }
    

}
