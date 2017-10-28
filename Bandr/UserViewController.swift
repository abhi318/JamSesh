//
//  UserViewController.swift
//  Bandr
//
//  Created by Abhinav Sangisetti on 10/25/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userBio: UILabel!
    
    var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = user?.name
        userBio.text = user?.bio
//        userInstrument.text = user.instrument
        loadPictures(images: (user?.images)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // need to send in images array
    func loadPictures(images: [UIImage]) {
        scrollView.delegate = self
        
        let numPics = images.count
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(numPics), height: self.scrollView.frame.height)
        
        //load pictures form user
        for i in 0..<numPics {
            let imgView = UIImageView()
            imgView.image = images[i]
            imgView.contentMode = .scaleAspectFit
            let xpos = self.view.frame.width * CGFloat(i)
            imgView.frame = CGRect(x: xpos, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
            self.scrollView.addSubview(imgView)
        }

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
