//
//  signin.swift
//  Bandr
//
//  Created by Kevin Zhang on 10/28/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import UIKit
import Foundation

class signupview: UIViewController {
    @IBOutlet weak var username :UITextField?
    @IBOutlet weak var email :UITextField?
    @IBOutlet weak var password :UITextField?
    
    @IBAction func SignUpTapped() {
            makeSignUpRequest()
            performSegue(withIdentifier: "toSwipe", sender: self)
    }
    
    //TODO : AUTHENTICATE USER LOGINS
    func makeSignUpRequest() -> Void {
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

