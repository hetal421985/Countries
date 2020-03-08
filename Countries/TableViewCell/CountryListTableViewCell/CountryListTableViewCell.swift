//
//  CountryListTableViewCell.swift
//  Countries
//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit
import SVGKit


class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var viewCountryFlag: UIView!
    @IBOutlet weak var imgViewCountryFlag: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
       
    }
    
    //MARK::
    //MARK:: Show Country Detail
    
    internal func showCountryDetailToTableViewCell(_ aCountryDetail:CountryListData) {
        
        if aCountryDetail.name !=  nil {
            lblCountryName.text = aCountryDetail.name
        }
        
        guard aCountryDetail.flag != nil else {
             return
        }
        
        self.imgViewCountryFlag.image =  (SVGKImage(contentsOf:URL(string:(aCountryDetail.flag)!)!))?.uiImage
    }

    
}
