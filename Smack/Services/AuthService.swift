//
//  AuthService.swift
//  Smack
//
//  Created by Kadir Kutluhan Alev on 21.04.2019.
//  Copyright © 2019 Jonny B. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKeyPath: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    
    var userEmail : String {
        get {
            return defaults.value(forKeyPath: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    func registerUser(email:String,password:String , completion : @escaping completionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        
        
        
        let body : [String:Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil {
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email : String, password: String, completion: @escaping completionHandler) {
        
        let lowerCaseEmail  = email.lowercased()
        
        let body : [String:Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {

                
                // using swiftyJson
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
                }
                catch {
                    print("hata olustur")
                    completion(false)
                    debugPrint(response.result.error as Any)
                }
                

                
                
                // normal way without 3.part  library
//                if let json = response.result.value as? Dictionary<String,Any> {
//
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
            }
        }
        
        
    }
    func createUser(name : String , email : String , avatarName : String , avatarColor : String , completion : @escaping completionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body : [String:Any] = [
            "name" : name,
            "email" : lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        let header = [
            "Authorization" : "Bearer \(AuthService.instance.authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let id = json["_id"].stringValue
                    // unwrap yapmamıza gerke yok çünkü json bizim için veri yoksa boş string atar
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                }catch {
                    
                }
                
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }

    }
}


