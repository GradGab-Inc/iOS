//
//  StudentEnrollVC.swift
//  Gradgap
//
//  Created by iMac on 11/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

class StudentEnrollVC: UIViewController {

    @IBOutlet weak var navigationBar: ReuseNavigationBar!
    @IBOutlet weak var profileImgView: ImageView!
    
    var selectImg : UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.headerLbl.text = ""
        navigationBar.backBtn.addTarget(self, action: #selector(self.clickToBack), for: .touchUpInside)
        navigationBar.filterBtn.isHidden = true
        
    }
    
    //MARK: - configUI
    func configUI() {
        
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        if selectImg.size.width != 0 {
            let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "SchoolListVC") as! SchoolListVC
            vc.selectImg = selectImg
            vc.isMentor = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            displayToast("Please select student enrollment ID.")
        }
    }
    
    @IBAction func clickToUpload(_ sender: Any) {
        CameraAttachment.shared.showAttachmentActionSheet(vc: self)
        CameraAttachment.shared.imagePickedBlock = { pic in
            self.profileImgView.image = pic
            self.selectImg = pic
        }
    }
    
    deinit {
        log.success("StudentEnrollVC Memory deallocated!")/
    }
    
}
