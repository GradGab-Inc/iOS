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
    func getSelectedSchoolArray(_ selectedData : MajorListDataModel)
}


class SchoolListView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchBackView: View!
    
    
    var flag : Int = 1
    var isRegisterd : Bool = false
    var delegate : selectedSchoolDelegate?
    var majorCurrentPage : Int = 1
    var languageCurrentPage : Int = 1
    var schoolCurrentPage : Int = 1
    var dataModel : MajorListModel = MajorListModel()
    
    var schoolListVM : SchoolSearchListViewModel = SchoolSearchListViewModel()
    var schoolListArr : [MajorListDataModel] = [MajorListDataModel]()
    
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
        searchBackView.isHidden = true
        
        if flag == 1 {
            majorListVM.delegate = self
            if majorListArr.count == 0 {
                serviceCallMajor()
            }
            else {
                listArr = majorListArr
                tblView.reloadData()
            }
        }
        else if flag == 2 {
            languageListVM.delegate = self
            if languageListArr.count == 0 {
                serviceCallLanguage()
            }
            else {
                listArr = languageListArr
                tblView.reloadData()
            }
        }
        else if flag == 3 {
            searchBackView.isHidden = false
            schoolListVM.delegate = self
            searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            listArr = schoolListArr
            tblView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if searchTxt.text?.trimmed != "" {
            schoolCurrentPage = 1
            serviceCallSchool()
        }
        else {
            schoolListArr = [MajorListDataModel]()
            listArr = [MajorListDataModel]()
            self.tblView.reloadData()
        }
    }
    
    func serviceCallMajor()  {
        let request = MorePageRequest(page: majorCurrentPage)
        majorListVM.majorList(request: request)
    }
    
    func serviceCallLanguage()  {
        let request = MorePageRequest(page: languageCurrentPage)
        languageListVM.languageList(request: request)
    }
    
    func serviceCallSchool() {
        let request = SchoolSearchRequest(text: searchTxt.text ?? "", page: schoolCurrentPage)
        schoolListVM.schoolSearchList(request: request)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if flag == 1 {
             if listArr.count - 2 == indexPath.row {
                if dataModel.hasMore {
                    majorCurrentPage = majorCurrentPage + 1
                    serviceCallMajor()
                }
            }
        }
        else if flag == 2 {
            if listArr.count - 2 == indexPath.row {
                if dataModel.hasMore {
                    languageCurrentPage = languageCurrentPage + 1
                    serviceCallLanguage()
                }
            }
        }
        else if flag == 3 {
             if listArr.count - 2 == indexPath.row {
                if dataModel.hasMore {
                    schoolCurrentPage = schoolCurrentPage + 1
                    serviceCallSchool()
                }
            }
        }
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
        else if flag == 3 {
            delegate?.getSelectedSchoolArray(listArr[indexPath.row])
            self.removeFromSuperview()
        }
    }
}

extension SchoolListView : MajorListSuccessDelegate, LanguageListSuccessDelegate, SchoolSearchListSuccessDelegate {
    func didReceivedMajorData(response: MajorListModel) {
        dataModel = response
        if majorCurrentPage == 1 {
            majorListArr = [MajorListDataModel]()
            listArr = [MajorListDataModel]()
        }
        for item in response.data {
            majorListArr.append(item)
            listArr.append(item)
        }
        tblView.reloadData()
    }
    
    func didReceivedLanguageData(response: MajorListModel) {
        dataModel = response
        if languageCurrentPage == 1 {
            listArr = [MajorListDataModel]()
            languageListArr = [MajorListDataModel]()
        }
        for item in response.data {
            languageListArr.append(item)
            listArr.append(item)
        }
        tblView.reloadData()
    }
    
    func didReceivedData(response: MajorListModel) {
        dataModel = response
        if schoolCurrentPage == 1 {
            schoolListArr = [MajorListDataModel]()
            listArr = [MajorListDataModel]()
        }
        for item in response.data {
            schoolListArr.append(item)
            listArr.append(item)
        }
        tblView.reloadData()
    }

}
