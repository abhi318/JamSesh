//
//  HTTPHelper.swift
//  BagelsInBed
//
//  Created by Abhinav Sangisetti on 8/17/17.
//  Copyright © 2017 Abhinav Sangisetti. All rights reserved.
//

import Foundation

enum HTTPRequestAuthType {
    case httpBasicAuth
    case httpTokenAuth
}

enum HTTPRequestContentType {
    case httpJsonContent
    case httpMultipartContent
}

struct HTTPHelper {
    static let API_AUTH_NAME = "asangisetti"
    static let API_AUTH_PASSWORD = "Aal3omOSqm"
    static let BASE_URL = "https://glacial-ocean-74844.herokuapp.com/api"
    
    func buildRequest(_ path: String!, method: String, authType: HTTPRequestAuthType,
                      requestContentType: HTTPRequestContentType = HTTPRequestContentType.httpJsonContent, requestBoundary:String = "") -> NSMutableURLRequest {
        // 1. Create the request URL from path
        print(path)
        let requestURL = URL(string: HTTPHelper.BASE_URL + "/" + path)
        print(requestURL!)
        let request = NSMutableURLRequest(url: requestURL!)
        
        // Set HTTP request method and Content-Type
        request.httpMethod = method
        
        // 2. Set the correct Content-Type for the HTTP Request. This will be multipart/form-data for photo upload request and application/json for other requests in this app
        switch requestContentType {
        case .httpJsonContent:
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        case .httpMultipartContent:
            let contentType = "multipart/form-data; boundary=" + requestBoundary
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        // 3. Set the correct Authorization header.
        switch authType {
        case .httpBasicAuth:
            // Set BASIC authentication header
            let basicAuthString = HTTPHelper.API_AUTH_NAME + ":" + HTTPHelper.API_AUTH_PASSWORD
            let utf8str = basicAuthString.data(using: String.Encoding.utf8)
            let base64EncodedString = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            request.addValue("Basic \(base64EncodedString!)", forHTTPHeaderField: "Authorization")
        case .httpTokenAuth:
            // Retreieve Auth_Token from Keychain
            if let userToken = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService") as String? {
                // Set Authorization header
//                print(userToken as String)
                request.addValue("Token token=" + (userToken), forHTTPHeaderField: "Authorization")
            }
        }
        
        return request
    }
    
    
    func sendRequest(_ request: URLRequest, completion:@escaping (Data?, NSError?) -> Void) -> () {
        // Create a NSURLSession task
        let session = URLSession.shared
        //print("hello")

        let task = session.dataTask(with: request) { (data: Data!, response: URLResponse!, error: Error!) -> Void in
            print("hello1")

            if error != nil{
                DispatchQueue.main.async(execute: { () -> Void in
                    completion(data, error as NSError?)
                })
                return
            }

            
            DispatchQueue.main.async(execute: { () -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(data, nil)
                    } else {
                        do {
                            let errorDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                            let responseError : NSError = NSError(domain: "HTTPHelperError", code: httpResponse.statusCode, userInfo: errorDict as? [AnyHashable: Any] as! [String : Any])
                            //print(httpResponse.statusCode)
                            //print(responseError.localizedDescription)
                            print(errorDict?.allKeys)
                            completion(data, responseError)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            })
        }
        //print("hello3")

        // start the task
        task.resume()
    }
    
//    func uploadRequest(_ path: String, data: Data, title: String) -> NSMutableURLRequest {
//        let boundary = "---------------------------14737809831466499882746641449"
//        let request = buildRequest(path, method: "POST", authType: HTTPRequestAuthType.httpTokenAuth,
//                                   requestContentType:HTTPRequestContentType.httpMultipartContent, requestBoundary:boundary) as NSMutableURLRequest
//        
//        let bodyParams : NSMutableData = NSMutableData()
//        
//        // build and format HTTP body with data
//        // prepare for multipart form uplaod
//        
//        let boundaryString = "--\(boundary)\r\n"
//        let boundaryData = boundaryString.data(using: String.Encoding.utf8) as Data!
//        bodyParams.append(boundaryData!)
//        
//        // set the parameter name
//        let imageMeteData = "Content-Disposition: attachment; name=\"image\"; filename=\"photo\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(imageMeteData!)
//        
//        // set the content type
//        let fileContentType = "Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(fileContentType!)
//        
//        // add the actual image data
//        bodyParams.append(data)
//        
//        let imageDataEnding = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(imageDataEnding!)
//        
//        _ = "--\(boundary)\r\n"
//        let boundaryData2 = boundaryString.data(using: String.Encoding.utf8) as Data!
//        
//        bodyParams.append(boundaryData2!)
//        
//        // pass the caption of the image
//        let formData = "Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(formData!)
//        
//        let formData2 = title.data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(formData2!)
//        
//        let closingFormData = "\r\n".data(using: String.Encoding.utf8, allowLossyConversion: false)
//        bodyParams.append(closingFormData!)
//        
//        let closingData = "--\(boundary)--\r\n"
//        let boundaryDataEnd = closingData.data(using: String.Encoding.utf8) as Data!
//        
//        bodyParams.append(boundaryDataEnd!)
//        
//        request.httpBody = bodyParams as Data
//        return request
//    }
    
    func getErrorMessage(_ error: NSError) -> NSString {
        var errorMessage : NSString
        
        // return correct error message
        if error.domain == "HTTPHelperError" {
            let userInfo = error.userInfo as NSDictionary!
            errorMessage = userInfo?.value(forKey: "message") as! NSString
        } else {
            errorMessage = error.description as NSString
        }

        return errorMessage
    }
}

open class KeychainAccess {
    fileprivate class func secClassGenericPassword() -> String {
        return NSString(format: kSecClassGenericPassword) as String
    }
    
    fileprivate class func secClass() -> String {
        return NSString(format: kSecClass) as String
    }
    
    fileprivate class func secAttrService() -> String {
        return NSString(format: kSecAttrService) as String
    }
    
    fileprivate class func secAttrAccount() -> String {
        return NSString(format: kSecAttrAccount) as String
    }
    
    fileprivate class func secValueData() -> String {
        return NSString(format: kSecValueData) as String
    }
    
    fileprivate class func secReturnData() -> String {
        return NSString(format: kSecReturnData) as String
    }
    
    open class func setPassword(_ password: String, account: String, service: String = "keyChainDefaultService") {
        let secret: Data = password.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let objects: Array = [secClassGenericPassword(), service, account, secret] as [Any]
        
        let keys: Array = [secClass(), secAttrService(), secAttrAccount(), secValueData()]
        
        let query = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
        
        SecItemDelete(query as CFDictionary)
        
        _ = SecItemAdd(query as CFDictionary, nil)
    }
    
    open class func passwordForAccount(_ account: String, service: String = "keyChainDefaultService") -> String? {
//        let queryAttributes = NSDictionary(objects: [secClassGenericPassword(), service, account, true], forKeys: [secClass() as NSCopying, secAttrService() as NSCopying, secAttrAccount() as NSCopying, secReturnData() as NSCopying])
//        
//        let dataTypeRef : AnyObject? = nil
//        _ = SecItemCopyMatching(queryAttributes, dataTypeRef as CFTypeRef as? UnsafeMutablePointer<CFTypeRef?>)
//        
//        if dataTypeRef == nil {
//            return nil
//        }
//        
//        let retrievedData : Data = dataTypeRef as! Data
//        let password = NSString(data: retrievedData, encoding: String.Encoding.utf8.rawValue)
//        
//        print(retrievedData.description)
//        return (password! as String)
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [secClassGenericPassword(), service, account, true], forKeys: [secClass() as NSCopying, secAttrService() as NSCopying, secAttrAccount() as NSCopying, secReturnData() as NSCopying])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
    open class func deletePasswordForAccount(_ password: String, account: String, service: String = "keyChainDefaultService") {
        let secret: Data = password.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let objects: Array = [secClassGenericPassword(), service, account, secret] as [Any]
        
        let keys: Array = [secClass(), secAttrService(), secAttrAccount(), secValueData()]
        let query = NSDictionary(objects: objects, forKeys: keys as [NSCopying])
        
        SecItemDelete(query as CFDictionary)
    }
}
