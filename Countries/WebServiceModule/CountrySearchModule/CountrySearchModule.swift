//
//  CountrySearchModule.swift
//  Countries
//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit
import Alamofire

class CountrySearchModule: NSObject {

     static let sharedInstance: CountrySearchModule = CountrySearchModule()
    
    //MARK::
    //MARK:: Call Web Service To Get List Of Searched Country
    
    internal func getSearchedCountryList(_ aStrCountryName:String,_ aView:UIView, completion: @escaping([CountryListData]?) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
          
            let path = Constants.APIMethodName.SearchCountry + aStrCountryName
            
            let url =  APIhandler.sharedInstance.getURL(path:path, pathVariables:nil, queryParams:nil)
            
            APIhandler.sharedInstance.getReponseForSearchedCountryName(requestURL:url, bodyPerameter:nil, methodName:.get) { (countryList, Error) in
           
                guard Error == nil else {
                    completion(nil)
                    return
                }
                completion(countryList)
            }
            
        } else {
            
            aView.makeToast(Constants.Message.NoInternetConnection)
            
        }
    }
    
}
