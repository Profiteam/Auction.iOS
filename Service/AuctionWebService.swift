//
//  AuctionWebService.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuctionWebService: NSObject {
    
    func POSTQuery(endpoint: String, params: [String: Any]? = nil, success:@escaping (_ responseObject: Any?) -> Void ,failure: @escaping (_ error: String?) -> Void ) {
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: APIManager.headers())
            .validate(statusCode: 200...200)
            .responseData { response in
                
                switch response.result
                {
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    print(error)
                    failure(error.localizedDescription)
                    
                case .success(let responseData):
                    success(responseData)
                }
        }
    }
        
    
    func GETQuery(endpoint: String, params: [String: Any]? = nil, success:@escaping (_ responseObject: Any?) -> Void ,failure: @escaping (_ error:
        String?) -> Void ) {
        
        Alamofire.request(endpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIManager.headers())
            .validate(statusCode: 200...200)
            .responseData { response in

                switch response.result
                {
                case .failure(let error):
                    if let data = response.data {
                        print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                    }
                    print(error)
                    failure(error.localizedDescription)
                case .success(let responseData):
                    success(responseData)
                }
        }
    }
    
    func UPLOADQuery(endpoint: String, file: Data?, parameters: [String: Any], success: @escaping (_ responseObject: Any?) -> Void ,failure: @escaping (_ error:
        String?) -> Void ) {

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = file {
                multipartFormData.append(data, withName: "fileset", fileName: "file.jpg", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: endpoint, method: .post, headers: APIManager.headers()) { (result) in
            switch result{
            case .success(let responseData):
                print(responseData)
                success(responseData)
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }
    }
}

class APIManager {
    class func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Authorization": "application/json"
        ]
        
        if UserDefaults.standard.string(forKey: "token") != nil {
            headers["Authorization"] = "Token " + UserDefaults.standard.string(forKey: "token")!
        }
        
        return headers
    }
}


extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
