//
//  CoreDataManager.swift
//  Countries
//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit
import CoreData
import SVGKit

class CoreDataManager: NSObject {

    class var sharedInstance: CoreDataManager
    {
        let SharedInstance: CoreDataManager = { CoreDataManager() }()
        
        return SharedInstance
    }
    
    //MARK::
    //MARK:: Insert Record To CoreData
    
    internal func saveCountryDetailToCoreData(_ aDictCountryDetail:CountryListData,_ aView:UIView) {
    
        let managedContext = Constants.kAppDelegate.persistentContainer.viewContext
        let countryDetailEntity = NSEntityDescription.entity(forEntityName: "CountryList", in: managedContext)!
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CountryList")
        fetchRequest.predicate = NSPredicate(format: "name = %@",aDictCountryDetail.name!)
        
         do {
        
            let countryList = try managedContext.fetch(fetchRequest)
            
            guard countryList.count == 0 else {
                
                aView.makeToast("Country Already Saved.")
                return
            }
            
            let country = NSManagedObject(entity: countryDetailEntity, insertInto: managedContext)
        
            country.setValue(aDictCountryDetail.name, forKeyPath: "name")
            country.setValue(aDictCountryDetail.capital, forKey: "capital")
            country.setValue(aDictCountryDetail.region, forKey: "region")
            country.setValue(aDictCountryDetail.subregion, forKey: "subregion")
            country.setValue(aDictCountryDetail.timezones!.joined(separator:","), forKey: "timezones")
            country.setValue(aDictCountryDetail.callingCodes!.joined(separator:","), forKey: "callingCodes")
            country.setValue(aDictCountryDetail.callingCodes!.joined(separator:","), forKey: "callingCodes")
            country.setValue(aDictCountryDetail.languages![0].name, forKey: "languages")
            country.setValue(aDictCountryDetail.currencies![0].name, forKey: "currencies")
            
            country.setValue((SVGKImage(contentsOf:URL(string:(aDictCountryDetail.flag)!)!))?.uiImage.pngData(), forKey: "flag")
           
            try managedContext.save()
             aView.makeToast("Country Saved Successfully.")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    //MARK::
    //MARK:: Fetched Already Saved Country
    
    internal func fetchAlreadySavedCountry() -> [[String:Any]] {
        
        let managedContext = Constants.kAppDelegate.persistentContainer.viewContext
       
        var arrCountryList:[[String:Any]] = [[:]]
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryList")
        
        arrCountryList.remove(at:0)
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
               
                var aDictCountryDetail:[String:Any] = [:]
                aDictCountryDetail["name"] = data.value(forKey:"name") as? String
                aDictCountryDetail["capital"] = (data.value(forKey:"capital") as! String)
                aDictCountryDetail["region"] = (data.value(forKey:"region") as! String)
                aDictCountryDetail["subregion"] = (data.value(forKey:"subregion") as! String)
                aDictCountryDetail["languages"] = (data.value(forKey:"languages") as! String)
                aDictCountryDetail["callingCodes"] = (data.value(forKey:"callingCodes") as! String)
                
                aDictCountryDetail["timezones"] = (data.value(forKey:"timezones") as! String)
                aDictCountryDetail["currencies"] = (data.value(forKey:"currencies") as! String)
                 aDictCountryDetail["flag"] = (data.value(forKey:"flag") as! Data)
                arrCountryList.append(aDictCountryDetail)
            }
            
        } catch {
            print("Failed")
        }
        return arrCountryList
    }
    
}
