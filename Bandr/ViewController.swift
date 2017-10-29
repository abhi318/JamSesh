//
//  ViewController.swift
//  Bandr
//
//  Created by Abhinav Sangisetti on 10/23/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

import UIKit
import os.log

private var numberOfUsers: Int = 5
var allUsers = [User]()

class ViewController: UIViewController {
    
    @IBOutlet weak var cardView: KolodaView!
    
    fileprivate var dataSource: [UIImage] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if(allUsers.count == 0) {
            loadSamples()
            saveUsers()
        }
        
        allUsers = loadUsers()!
        fillKolodaDeck()
        
        cardView.dataSource = self
        cardView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSamples() {
        let ryan = User(name: "Ryan Woodlock", bio: "wasup I play guitar and drums hit me up to form a pavement ripoff band", instrument: "Guitar", images:[])
        let shamika = User(name: "Shamika", bio: "hey I'm Shamika, I play bass and keys, I like playing psych rock, let's jam", instrument: "Bass", images:[])
        for i in 0..<4 {
            ryan.addPic(image: UIImage (named: "Ryan_\(i+1)")!)
            shamika.addPic(image: UIImage (named: "Shamika_\(i+1)")!)
        }
        allUsers.append(ryan)
        allUsers.append(shamika)
    }
    
    func loadUsers() -> [User]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
    
    func saveUsers() {
        print("saved")
        print(allUsers.count)
        for i in 0..<allUsers.count {
            print(allUsers[i].name)
        }
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(allUsers, toFile: User.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Users successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save users...", log: OSLog.default, type: .error)
        }
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        cardView?.swipe(.left)
    }
    @IBAction func rightButtonTapped() {
        cardView?.swipe(.right)
    }
    @IBAction func undoButtonTapped() {
        cardView?.revertAction()
    }
    
    func fillKolodaDeck() {
        var array: [UIImage] = []
        for i in 0..<allUsers.count {
            array.append(allUsers[i].images![0])
        }
        dataSource = array
    }
    
    //    func addToKolodaDeck() {
    //        dataSource.append(allUsers[allUsers.count-1].images![0])
    //        //cardView.reloadData()
    //    }
    
}

// MARK: KolodaViewDelegate

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //        let position = cardView.currentCardIndex
        //        for i in 0..<allUsers.count {
        //            dataSource.append(allUsers[i].images![0])
        //        }
        //        cardView.insertCardAtIndexRange(position..<position + allUsers.count, animated: true)
        print("No more people to match with")
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as? UserViewController
        {
            vc.user = allUsers[index]
            present(vc, animated: true, completion: nil)
        }
    }
    
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let v = UIView()
        let image = UIImageView(image: dataSource[Int(index)])
        let name = UILabel()
        let instrument = UILabel()
        v.frame = CGRect(x: 0, y: 0, width: cardView.frame.width, height: cardView.frame.height)
        v.backgroundColor = cardView.backgroundColor
        
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x:0, y:0, width: v.frame.width, height: v.frame.height/8 * 7)
        name.frame = CGRect(x: 0, y: v.frame.height/8 * 7, width: v.frame.width, height: v.frame.height/14)
        instrument.frame = CGRect(x: 0, y: v.frame.height/8 * 7 + v.frame.height/14, width: v.frame.width, height: v.frame.height/14)
        print(v.frame.minY)
        if(index < allUsers.count) {
            name.text = allUsers[index].name
            name.font = name.font.withSize(30)
            name.textColor = UIColor.black
            instrument.text = allUsers[index].instrument
            instrument.font = instrument.font.withSize(20)
            instrument.textColor = UIColor.black
            
        }
        
        v.addSubview(image)
        v.addSubview(name)
        v.addSubview(instrument)
        
        return v
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

