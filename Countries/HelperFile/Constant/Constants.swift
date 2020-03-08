//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit

struct Constants {

  static let kMainStoryBoard = UIStoryboard.init(name:"Main", bundle:Bundle.main)
  static let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
    
  struct APIMethodName  {
    
     static let SearchCountry = "name/"
  }
    
    struct Message {
        
         static let NoInternetConnection = "No Internet Connection."
    }

}
