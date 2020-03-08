//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit
import SVGKit

class CountryDetailViewController: UIViewController {

    @IBOutlet var lblCollection: [UILabel]!
    @IBOutlet weak var imgViewCountryFlag: UIImageView!
    @IBOutlet weak var btnSaveDetail: UIButton!
    
    var aDictCountryDetail:CountryListData?
    var aDictCountryOffline:[String:Any]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard Reachability.isConnectedToNetwork()  else {
            
            showOfflineCountryDataToView()
            return
        }
        showCountryDataToView()
    }
   
    //MARK::
    //MARK:: IBAction Back Click
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated:true)
    }
    
    //MARK::
    //MARK:: IBAction Save Country Detail Click
    
    @IBAction func btnSaveCountryDetailClick(_ sender: UIButton) {
    CoreDataManager.sharedInstance.saveCountryDetailToCoreData(aDictCountryDetail!,self.view)
    }
}

extension CountryDetailViewController {
    
    //MARK::
    //MARK:: Show Country Data To View
    
    fileprivate func showCountryDataToView() {
        
        btnSaveDetail.isHidden = false
        
        if aDictCountryDetail?.name != nil {
            lblCollection[0].text = aDictCountryDetail?.name // Name
        }
        if aDictCountryDetail?.capital != nil {
             lblCollection[1].text = aDictCountryDetail?.capital // Capital
        }
        if aDictCountryDetail?.callingCodes != nil {
            lblCollection[2].text = aDictCountryDetail?.callingCodes!.joined(separator:",")// Calling Code
        }
        if aDictCountryDetail?.region != nil {
            lblCollection[3].text = aDictCountryDetail?.region // Region
        }
        if aDictCountryDetail?.subregion != nil {
            lblCollection[4].text = aDictCountryDetail?.subregion // SubRegion
        }
        if aDictCountryDetail?.timezones != nil {
            lblCollection[5].text = aDictCountryDetail?.timezones!.joined(separator:",") // TimeZone
        }
        if aDictCountryDetail?.currencies != nil {
            
            lblCollection[6].text = aDictCountryDetail?.currencies![0].name // Currency
        }
        if aDictCountryDetail?.languages != nil {
            lblCollection[7].text = aDictCountryDetail?.languages![0].name // Language
        }
        guard aDictCountryDetail!.flag != nil else {
            return
        }
        
        self.imgViewCountryFlag.image =  (SVGKImage(contentsOf:URL(string:(aDictCountryDetail!.flag)!)!))?.uiImage
      
    }
   
    //MARK::
    //MARK:: Show Offline Country Detail Data
    
    fileprivate func showOfflineCountryDataToView() {
        
        btnSaveDetail.isHidden = true
        lblCollection[0].text = (aDictCountryOffline!["name"] as! String) // Name
        lblCollection[1].text = (aDictCountryOffline!["capital"] as! String) // Capital
        lblCollection[2].text = (aDictCountryOffline!["callingCodes"] as! String)// Calling Code
        lblCollection[3].text = (aDictCountryOffline!["region"] as! String) // Region
        lblCollection[4].text = (aDictCountryOffline!["subregion"] as! String) // SubRegion
        lblCollection[5].text = (aDictCountryOffline!["timezones"] as! String)// TimeZone
        lblCollection[6].text = (aDictCountryOffline!["currencies"] as! String) // Currency
        lblCollection[7].text = (aDictCountryOffline!["languages"] as! String) // Language
        self.imgViewCountryFlag.image = UIImage(data:aDictCountryOffline!["flag"] as! Data,scale:1.0) //Flag
      
    }
    
}
