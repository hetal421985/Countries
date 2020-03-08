//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import Foundation
import Alamofire

extension APIhandler {
    
    //MARK::
    //MARK:: Get Response For Country List
    
    func getReponseForSearchedCountryName(requestURL:URL, bodyPerameter: [String:Any]?,methodName:HTTPMethod,completion: @escaping([CountryListData]?, String?) -> Void) {
    
        getResponse(method:methodName, url:requestURL, bodyData:bodyPerameter) { (countryList,Error) in
            
            completion(countryList,Error)
        }
   }
    
   
}
