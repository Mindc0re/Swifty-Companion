//
//  APIController.swift
//  SwiftyCompanion
//
//  Created by Simon GAUDIN on 1/30/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

let UID = "6c362a61c46eff2493a4dc655d87ee7bcd9598c413087f8f586c6e0fdc0f7921"
let SECRET = "a90f19a23137189849fdb82063f5c0eacfbfb87ff25d8c20e8ab230082fadee0"
let BEARER = (UID + ":" + SECRET).data(using: String.Encoding.utf8)
let ENCODED_BEARER = BEARER?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

class APIController
{
    var accessToken: String? = nil
    
    func getAccessToken(completionHandler: @escaping (Error?) -> Void)
    {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                completionHandler(err)
            }
            else if let _ = response {
                if let d = data {
                    do
                    {
                        let json = try JSON(data: d)
                        if let tkn = json["access_token"].string {
                            self.accessToken = tkn
                            completionHandler(nil)
                        }
                        else {
                            completionHandler("Error JSON Access_Token" as? Error)
                        }
                    }
                    catch(let e) { completionHandler(e) }
                    
                }
            }
        }
        
        task.resume()
    }
    
    func getAllUsers(query: String, completionHandler: @escaping(JSON?) -> Void)
    {
        guard let formattedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlStr = URL(string: "https://api.intra.42.fr/v2/users?per_page=5&range[login]=\(formattedQuery),\(formattedQuery + "z")&sort=login")
        guard let url = urlStr else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { completionHandler(nil) }
            else if let _ = response {
                if let d = data {
                    do {
                        let json = try JSON(data: d)
                        completionHandler(json)
                    }
                    catch (_) { completionHandler(nil) }
                }
                else { completionHandler(nil) }
            }
            else { completionHandler(nil) }
        }
        task.resume()
    }
    
    func getUserByName(login: String, completionHandler: @escaping(JSON?) -> Void)
    {
        guard let formattedLogin = login.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { completionHandler(nil); return }
        let urlStr = URL(string: "https://api.intra.42.fr/v2/users/\(formattedLogin)")
        guard let url = urlStr else { completionHandler(nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { completionHandler(nil) }
            else if response != nil {
                if let d = data {
                    do {
                        let json = try JSON(data: d)
                        completionHandler(json)
                    }
                    catch(_) { completionHandler(nil) }
                }
                else { completionHandler(nil) }
            }
            else { completionHandler(nil) }
        }
        
        task.resume()
    }
    
    func getCoalition(login: String, completionHandler: @escaping(COALITION?) -> Void)
    {
        guard let formattedLogin = login.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { completionHandler(nil); return }
        let urlStr = URL(string: "https://api.intra.42.fr/v2/users/\(formattedLogin)/coalitions")
        guard let url = urlStr else { completionHandler(nil); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { completionHandler(nil) }
            else if response != nil {
                if let d = data {
                    do {
                        let json = try JSON(data: d)
                        completionHandler(COALITION(rawValue: json[0]["id"].intValue))
                    }
                    catch(_) { completionHandler(nil) }
                }
                else { completionHandler(nil) }
            }
            else { completionHandler(nil) }
        }
        
        task.resume()
    }
    
}
