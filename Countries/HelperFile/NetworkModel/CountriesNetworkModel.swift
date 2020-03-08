//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import Foundation

struct CountryListData:Codable {
    
    var name:String?
    var alpha2Code:String?
    var alpha3Code:String?
    var area: Double?
    var capital:String?
    var cioc:String?
    var demonym:String?
    var flag:String?
    var gini:Double?
    var nativeName:String?
    var numericCode:String?
    var population:Int?
    var region:String?
    var subregion:String?
    var topLevelDomain:[String]?
    var callingCodes:[String]?
    var altSpellings:[String]?
    var latlng:[Double]?
    var timezones:[String]?
    var borders:[String]?
    var currencies:[CountryCurrency]?
    var languages:[CountryLanguage]?
    var regionalBlocs: [RegionBlocs]?
   
}

struct CountryLanguage:Codable{
    
    var iso639_1:String?
    var iso639_2:String?
    var name:String?
    var nativeName:String?
}

struct CountryCurrency:Codable{
    
    var code:String?
    var name:String?
    var symbol:String?
}


struct RegionBlocs:Codable {
    
    var acronym:String?
    var name:String?
    var otherAcronyms:[String]?
    var otherNames:[String]?
}
