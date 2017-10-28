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
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    var userImages = [UIImage]()
    var user: User? = nil
    
    @IBAction func deleteImageButton(_ button: UIButton) {
        switch button.tag {
        case 1:
            img1.image = UIImage(named:"Like")
            break
        case 2:
            img2.image = UIImage(named:"Like")
            break
        case 3:
            img3.image = UIImage(named:"Like")
            break
        case 4:
            img4.image = UIImage(named:"Like")
            break
        case 5:
            img5.image = UIImage(named:"Like")
            break
        case 6:
            img6.image = UIImage(named:"Like")
            break
        default:
            break
        }
        userImages.remove(at: (button.tag - 1))
        
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
    
    @IBAction func saveUser(_ sender: Any) {
        user = User(name: userName.text!, bio: userBio.text, instrument: "instrument", images: userImages)
        
        if let presenter = presentingViewController as? ViewController {
            presenter.allUsers.append(user!)
            presenter.saveUsers()
        }
        dismiss(animated: true, completion: nil)
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
