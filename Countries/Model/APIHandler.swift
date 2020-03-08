 
 //  APIHandler.swift
 //
 //  Created by hetal on 07/03/20.
 //  Copyright © 2020 hetal. All rights reserved.
 //

import Foundation
import Alamofire

final class APIhandler: NSObject {
  
    class var sharedInstance: APIhandler
    {
        let SharedInstance: APIhandler = { APIhandler() }()
       
        return SharedInstance
    }
    
  
   func getBaseURL() -> String {
    
        return "https://restcountries.eu/rest/v2/"
    
    }
  
  //MARK::
  //MARK:: Method That Get URL By Adding Query Perameter
  
  
internal func getURL(path: String, pathVariables: [String:Any]?, queryParams: [String:Any]?) -> URL {
    
    var resultingPath = self.getBaseURL() + path
    
      if let pathVariables = pathVariables {
        for (key, value) in pathVariables {
          resultingPath = resultingPath.replacingOccurrences(of: key, with: "\(value)")
        }
    }
    
    let encodedString = resultingPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
    
    var urlComponents = URLComponents(string: encodedString!)
 
      if let queryParams = queryParams {
        urlComponents?.queryItems = []
        for (key, value) in queryParams {
          urlComponents?.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
        }
      }
    
    return urlComponents!.url!
  }
  
  //MARK::
  //MARK:: Method That Make Request For User API Which Require Firebase Token As Header
  
  internal func getDataRequest(url: URL, method: HTTPMethod, bodyData: [String:Any]?, completion: @escaping(DataRequest?, Error?) -> Void) {

    let dataRequest = request(url, method: method, parameters: bodyData, encoding: JSONEncoding.default, headers:nil)
    
      completion(dataRequest, nil)
    
    }
  
    
  //MARK::
  //MARK:: Method That Get Response
    
  internal func getResponse <CountryListData: Codable> (method: HTTPMethod, url: URL, bodyData: [String:Any]?, completion: @escaping ([CountryListData]?, String?) -> Void) {
    
    
    getDataRequest(url: url, method: method, bodyData: bodyData) { dataRequest, error in
      guard let dataRequest = dataRequest, error == nil else {
        completion(nil, error?.localizedDescription)
        return
      }
     
    
      dataRequest
        .response() { response in
         
          guard let data = response.data, response.error == nil else {
            completion(nil, response.error?.localizedDescription)
            return
          }
          do {

            let decodedData = try JSONDecoder().decode([CountryListData].self, from: data)
            completion(decodedData, nil)
          } catch {
              completion(nil,"Server Not Responding.")
          }
      }
    }
  }

}
