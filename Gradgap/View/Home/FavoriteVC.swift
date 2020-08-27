//
//  FavoriteVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class FavoriteVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var favoriteListVM : FavoriteListViewModel = FavoriteListViewModel()
    var favoriteListArr : [FavoriteDataModel] = [FavoriteDataModel]()
    var addToFavoriteVM : SetFavoriteViewModel = SetFavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
       
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Favorites"
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib(nibName: "FavoriteTVC", bundle: nil), forCellReuseIdentifier: "FavoriteTVC")
        
        noDataLbl.isHidden = true
        favoriteListVM.delegate = self
        addToFavoriteVM.delegate = self
        favoriteListVM.getFavoriteList()
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        log.success("FavoriteVC Memory deallocated!")/
    }
    
}

extension FavoriteVC : FavoriteListDelegate, SetFavoriteDelegate {
    func didRecieveSetFavoriteResponse(response: SuccessModel) {
        favoriteListVM.getFavoriteList()
    }
    
    func didRecieveFavoriteListResponse(response: FavoriteListModel) {
        favoriteListArr = [FavoriteDataModel]()
        favoriteListArr = response.data
        tblView.reloadData()
        
        noDataLbl.isHidden = favoriteListArr.count == 0 ? false : true
    }
}

//MARK: - TableView Delegate
extension FavoriteVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "FavoriteTVC", for: indexPath) as? FavoriteTVC
            else {
            return UITableViewCell()
        }
        
        let dict : FavoriteDataModel = favoriteListArr[indexPath.row]
        cell.nameLbl.text = dict.name
        cell.collegeNameLbl.text = dict.schoolName
        cell.ratinglbl.text = "\(dict.averageRating)"
        cell.ratingView.rating = dict.averageRating
        cell.profileImgView.downloadCachedImage(placeholder: "ic_profile", urlString: dict.image)
        cell.ratingBtn.tag = indexPath.row
        cell.ratingBtn.addTarget(self, action: #selector(self.clickToFavorite), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MentorsProfileVC") as! MentorsProfileVC
        vc.selectedUserId = favoriteListArr[indexPath.row].mentorRef
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickToFavorite(_ sender : UIButton) {
        let dict : FavoriteDataModel = favoriteListArr[sender.tag]
        addToFavoriteVM.addRemoveFavorite(reuqest: FavouriteRequest(mentorRef: dict.mentorRef, status: false))
    }
    
}
