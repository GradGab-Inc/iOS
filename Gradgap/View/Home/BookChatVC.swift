//
//  BookChatVC.swift
//  Gradgap
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class BookChatVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var timeCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!
    
    var messageArr = ["Ask a few quick questions!","Most popular option for a chat!","Perfect for a more in-depth chat!","Get the full story with a 1 hour chat!"]
    var timeArr = ["15","30","45","60"]
    var selectedIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = "Book Chat"
        navigationBar.filterBtn.isHidden = true
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
    }
    
    //MARK: - configUI
    func configUI() {
       timeCollectionView.register(UINib(nibName: "BookChatCVC", bundle: nil), forCellWithReuseIdentifier: "BookChatCVC")
    }
    
    //MARK: - Button Click
    @objc func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToConversation(_ sender: Any) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "ConversationStarterVC") as! ConversationStarterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToNext(_ sender: Any) {
        
    }
    
}


extension BookChatVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = timeCollectionView.dequeueReusableCell(withReuseIdentifier: "BookChatCVC", for: indexPath) as? BookChatCVC else {
            return UICollectionViewCell()
        }
        cell.timeBtn.setTitle(timeArr[indexPath.row], for: .normal)
        if selectedIndex == indexPath.row {
            cell.timeBtn.backgroundColor = RedColor
        }
        else {
            cell.timeBtn.backgroundColor = ClearColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        timeCollectionView.reloadData()
        messageLbl.text = messageArr[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        timeCollectionViewHeightConstraint.constant = timeCollectionView.frame.size.width/4
        return CGSize(width: timeCollectionView.frame.size.width/4, height: timeCollectionView.frame.size.width/4)
    }
    
}
