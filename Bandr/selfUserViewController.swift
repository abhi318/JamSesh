//
//  selfUserViewController.swift
//  Bandr
//
//  Created by Abhinav Sangisetti on 10/26/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import UIKit
import os.log

class selfUserViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userBio: UITextField!
    @IBOutlet weak var userInstrument: UITextField!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    var userImages = [UIImage]()
    var userImageViews = [UIImageView]()
    
    @IBAction func deleteImageButton(_ button: UIButton) {
        userImageViews[button.tag-1].image = nil
        if ((button.tag - 1) < userImages.count) {
            updateImages(at:(button.tag-1))
            userImages.remove(at: (button.tag - 1))
        }
        
    }
    @IBAction func addPhotoButton(_ sender: Any) {
        if (userImages.count == 6) {
            return
        }
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let user = User(name: userName.text!, bio: userBio.text, instrument: userInstrument.text, images: userImages)
        if segue.identifier == "addedNewUserSegue" {
            print("hello")
            print(segue.destination)
            if let vc = segue.destination as? ViewController {
                print("hello yo")
                allUsers.append(user)
                vc.saveUsers()
                //vc.addToKolodaDeck()
            }
        }
    }
    
    func updateImages(at: Int) {
        for i in at..<userImages.count-1 {
            userImageViews[i].image = userImageViews[i+1].image
        }
        userImageViews[userImages.count-1].image = nil
    }
    /*
     let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(users, toFile: User.ArchiveURL.path)
     if isSuccessfulSave {
     os_log("User successfully saved.", log: OSLog.default, type: .debug)
     } else {
     os_log("Failed to save user...", log: OSLog.default, type: .error)
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        userImageViews += [img1, img2, img3, img4, img5, img6]
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension selfUserViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        //let imageData:Data = UIImagePNGRepresentation(image_data!)!
        //let imageStr = imageData.base64EncodedString()
        switch userImages.count {
        case 0:
            img1.image = image_data
            break
        case 1:
            img2.image = image_data
            break
        case 2:
            img3.image = image_data
            break
        case 3:
            img4.image = image_data
            break
        case 4:
            img5.image = image_data
            break
        case 5:
            img6.image = image_data
            break
        default:
            break
        }
        userImages.append(image_data!)
        self.dismiss(animated: true, completion: nil)
    }
}

