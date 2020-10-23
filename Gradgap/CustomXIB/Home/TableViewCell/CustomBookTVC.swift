//
//  CustomBookTVC.swift
//  Gradgap
//
//  Created by iMac on 10/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit
import SainiUtils

protocol CustomBookTVCDelegate {
    func didRecieveCustomBookTVCResponse(_ id : String,_ timeSlote : Int)
}



class CustomBookTVC: UITableViewCell {

    @IBOutlet weak var profileImgView: ImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var collegeNameLbl: UILabel!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    
    var arrData : [Int] = [Int]()
    var userId : String = String()
    var delegate : CustomBookTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeCollectionView.register(UINib.init(nibName: "CollegeCVC", bundle: nil), forCellWithReuseIdentifier: "CollegeCVC")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


//MARK: - CollectionView Delegate
extension CustomBookTVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollegeCVC", for: indexPath) as? CollegeCVC else {
            return UICollectionViewCell()
        }
        
        let str : Int = arrData[indexPath.row]
        cell.lbl.font = UIFont(name: "MADETommySoft", size: 12.0)
        
//        let timeZone = timeZoneOffsetInMinutes()
//        let time = minutesToHoursMinutes(minutes: str + timeZone)
//        cell.lbl.text = getHourStringFromHoursString(strDate: "\(time.hours):\(time.leftMinutes)", formate: "hh:mm a")

        
        let startDate : Date = getDateFromDateString(strDate: "01-01-2001 " + "00:00 a", format: "dd-MM-yyyy hh:mm a") ?? Date()
        let date1 = Calendar.current.date(byAdding: .minute, value: timeZoneOffsetInMinutes() + str, to: startDate)
        
        cell.lbl.text = getDateStringFromDate1(date: date1 ?? Date(), format: "hh:mm a")

        
//        let startDate : Date = getDateFromDateString(strDate: "01-01-2001 " + "00:00 a", format: "dd-MM-yyyy hh:mm a")!
//        let date1 = Calendar.current.date(byAdding: .minute, value: timeZoneOffsetInMinutes() + str, to: startDate)!
//
//        cell.lbl.text = getDateStringFromDate1(date: date1, format: "hh:mm a")
        
        cell.cancelBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 85, height: 36)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didRecieveCustomBookTVCResponse(userId, indexPath.row)
    }
    
}

