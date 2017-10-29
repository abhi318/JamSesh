//
//  signin.swift
//  Bandr
//
//  Created by Kevin Zhang on 10/28/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import UIKit
import Foundation

class signin: UIViewController {
    
    @IBOutlet weak var username :UITextField?
    @IBOutlet weak var password :UITextField?
    
    @IBAction func SignInTapped() {

        if(!(username?.text?.isEmpty)! && !(password?.text?.isEmpty)!) {
            shouldPerformSegue(withIdentifier: "signing_in", sender: self)
        } else {
            let alertController = UIAlertController(title: "Parameters Required", message:
                "Some of the required parameters are missing", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "signing_in") {
            
            if(makeSignInRequest()) {
                return true
            }
            else {
                return false
            }
        }
        
        return false
    }
    
    
    //TODO : AUTHENTICATE USER LOGINS
    func makeSignInRequest() -> Bool {
        let httpHelper = HTTPHelper()
        let httpRequest = httpHelper.buildRequest("signin", method: "GET",
                                                  authType: HTTPRequestAuthType.httpBasicAuth)
        
        let encrypted_password = AESCrypt.encrypt(password?.text, password: HTTPHelper.API_AUTH_PASSWORD)
        httpRequest.httpBody = "{\"username\":\"\(self.username?.text)\",\"password\":\"\(encrypted_password)\"}".data(using: String.Encoding.utf8);
        
        httpHelper.sendRequest(httpRequest as URLRequest, completion: { (data: Data?, error: Error?) in

            if(error != nil) {
                _ = httpHelper.getErrorMessage(error! as NSError)
                return
            }
            
        })
            
        return true
    }
    @IBAction func SignUpTapped() {
        performSegue(withIdentifier: "signup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
