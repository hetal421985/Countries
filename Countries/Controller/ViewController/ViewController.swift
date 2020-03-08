//
//  ViewController.swift
//  Countries
//
//  Created by hetal on 07/03/20.
//  Copyright © 2020 hetal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var txtFldCountrySearch: UITextField!
    @IBOutlet weak var tblViewCountryList: UITableView!
    
    fileprivate var arrCountryList:[CountryListData] = []
    fileprivate var onSearch: ((UITextField) -> (Void))? = nil
    fileprivate var lastSearchText:String = ""
    fileprivate var isInternetAvailabel:Bool = true
    fileprivate var arrOfflineSavedCountry:[[String:Any]] = [[:]]
    fileprivate var arrOfflineOriginalSavedCountry:[[String:Any]] = [[:]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setDefaultSettingToView()
       
    }

}

extension ViewController {
    
    //MARK::
    //MARK:: User Define Method
    
    fileprivate func setDefaultSettingToView() {
        
        self.navigationController?.setNavigationBarHidden(true, animated:false)
        self.tblViewCountryList.register(UINib(nibName:"CountryListTableViewCell", bundle: nil), forCellReuseIdentifier:"CountryListTableViewCell")
        txtFldCountrySearch.addTarget(self, action: #selector(searchCountryAsPerText(_ :)), for: .editingChanged)
        searchCountry()
        showOfflineStoredCountryData()
       
    }
    
    //MARK::
    //MARK:: Search WFS ID AS Per Text
    
    @objc func searchCountryAsPerText(_ textfield:UITextField) {
        
        self.onSearch!(textfield)
    }
    
    //MARK::
    //MARK:: Search Country
    
    fileprivate func searchCountry() {
        
        self.onSearch = { textField in
            
            if(textField.text == ""){
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            let strSearchText = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.search(searchText:)), object: self.lastSearchText)
            self.perform(#selector(self.search(searchText:)), with: strSearchText, afterDelay: 0.2)
            self.lastSearchText = strSearchText
        }
    }
    
    //MARK::
    //MARK:: Search Country According To Text
    
    @objc func search(searchText: String) {
        
        guard isInternetAvailabel else {
            
            performLocalSearch(searchText)
            return
        }
        if(searchText.count != 0){
    
    CountrySearchModule.sharedInstance.getSearchedCountryList(searchText,self.view) { (countryList) in
        
        if self.arrCountryList.count > 0 {
            self.arrCountryList.removeAll()
        }
        
        guard countryList != nil else {
                
            self.tblViewCountryList.reloadData()
            self.lblNoRecordFound.isHidden = false
            self.tblViewCountryList.isHidden = true
            return
        }
        
            self.arrCountryList = countryList!
            self.tblViewCountryList.reloadData()
            self.lblNoRecordFound.isHidden = true
            self.tblViewCountryList.isHidden = false
            
            }
        } else {
            
            if self.arrCountryList.count > 0 {
                self.arrCountryList.removeAll()
            }
            self.tblViewCountryList.isHidden = true
        
        }
    }
    
    //MARK::
    //MARK:: Show Offline Data
    
    fileprivate func showOfflineStoredCountryData() {
        
        isInternetAvailabel = Reachability.isConnectedToNetwork()
        guard !isInternetAvailabel else {
            
            return
        }
        arrOfflineSavedCountry = CoreDataManager.sharedInstance.fetchAlreadySavedCountry()
        arrOfflineOriginalSavedCountry = arrOfflineSavedCountry
        tblViewCountryList.isHidden = false
        tblViewCountryList.reloadData()
    }
    
    //MARK::
    //MARK:: Perform Local Search
    
    fileprivate func performLocalSearch(_ searchString:String) {
        
        arrOfflineSavedCountry.removeAll()
        
        guard searchString.count != 0 else {
            
            arrOfflineSavedCountry = arrOfflineOriginalSavedCountry
            tblViewCountryList.reloadData()
            return
        }
       
        let predicate = NSPredicate(format: "SELF.name CONTAINS[cd] %@", searchString)
        let arrFilter = arrOfflineOriginalSavedCountry.filter { predicate.evaluate(with: $0) }
       
        if arrFilter.count > 0 {
            arrOfflineSavedCountry = arrFilter
        }
        tblViewCountryList.reloadData()
        
    }
    
}


extension ViewController:UITextFieldDelegate {
    
    //MARK::
    //MARK:: UITextField Delegate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}


extension ViewController:UITableViewDelegate,UITableViewDataSource {
    
    //MARK::
    //MARK:: UITableView Delegate And DataSource Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard isInternetAvailabel else {
            
            return arrOfflineSavedCountry.count
        }
        return arrCountryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aObjCountryListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as! CountryListTableViewCell
        
        if isInternetAvailabel {
        aObjCountryListTableViewCell.showCountryDetailToTableViewCell(arrCountryList[indexPath.row])
            
        } else {
            
            aObjCountryListTableViewCell.lblCountryName.text = (arrOfflineSavedCountry[indexPath.row]["name"] as! String)
            aObjCountryListTableViewCell.imgViewCountryFlag.image = UIImage(data:arrOfflineSavedCountry[indexPath.row]["flag"] as! Data,scale:1.0)
        }

        return aObjCountryListTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aObjCountryDetailViewController = Constants.kMainStoryBoard.instantiateViewController(withIdentifier:"CountryDetailViewController") as! CountryDetailViewController
        
        if isInternetAvailabel {
            aObjCountryDetailViewController.aDictCountryDetail = arrCountryList[indexPath.row]
        }else {
            aObjCountryDetailViewController.aDictCountryOffline = arrOfflineSavedCountry[indexPath.row]
        }
        
      self.navigationController?.pushViewController(aObjCountryDetailViewController, animated:true)
    }
}
