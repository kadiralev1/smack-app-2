//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Jonny B on 7/14/17.
//  Copyright © 2017 Jonny B. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    // Variables
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard let name = usernameTxt.text , usernameTxt.text != " " else {return}
        guard let email = emailTxt.text , emailTxt.text != " " else {return}
        guard let password = passwordTxt.text , passwordTxt.text != " " else {return}
        
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                print("Logged in user!",AuthService.instance.authToken)
                if success {
                    AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                        
                        if success {
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        }
                    })
                }
            })
         
            
        }
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorPressed(_ sender: Any) {
    }
}
