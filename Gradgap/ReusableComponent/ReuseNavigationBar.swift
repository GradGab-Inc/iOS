//
//  ReuseNavigationBar.swift
//  Gradgap
//
//  Created by iMac on 05/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit


class ReuseNavigationBar: UIView {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var filterBtn: UIButton!
    
    let nibName = "ReuseNavigationBar"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        
        self.addSubview(view)        
    }
    
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
