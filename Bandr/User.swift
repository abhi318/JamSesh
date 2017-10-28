//
//  User.swift
//  Bandr
//
//  Created by Abhinav Sangisetti on 10/26/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import Foundation
import UIKit
import os.log

class User: NSObject, NSCoding {
    let name: String
    var bio: String? = ""
    var instrument: String? = ""
    var images: [UIImage]? = []
    
    struct PropertyKey {
        static let name = "name"
        static let bio = "bio"
        static let instrument = "instrument"
        static let images = "images"
    }
    
    init(name: String, bio: String?, instrument: String?, images: [UIImage]?) {
        self.name = name
        self.bio = bio
        self.instrument = instrument
        self.images = images
    }
    
    func addBio (bio: String) {
        self.bio = bio
    }
    
    func addPic (image: UIImage) {
        images!.append(image)
    }
    
    func getName() -> String {
        return name
    }
    
    func getInstrument() -> String? {
        return instrument
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(bio, forKey: PropertyKey.bio)
        aCoder.encode(instrument, forKey: PropertyKey.instrument)
        aCoder.encode(images, forKey: PropertyKey.images)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a User.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let bio = aDecoder.decodeObject(forKey: PropertyKey.bio) as? String
        let instrument = aDecoder.decodeObject(forKey: PropertyKey.instrument) as? String
        let images = aDecoder.decodeObject(forKey: PropertyKey.images) as? [UIImage]
        
        self.init(name: name, bio: bio, instrument: instrument, images: images)
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("users")
}

