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

class ViewController: UIViewController {

    @IBOutlet weak var cardView: KolodaView!
    var allUsers = [User]()
    
    fileprivate var dataSource: [UIImage] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (loadUsers() == nil) {
            allUsers = []
        }
        else {
            allUsers = loadUsers()!
        }
        print("hello")
        fillKoladaDeck()
        cardView.dataSource = self
        cardView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUsers() -> [User]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? [User]
    }
    
    func saveUsers() {
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
    
    func fillKoladaDeck() {
        var array: [UIImage] = []
        for i in 0..<allUsers.count {
            array.append(UIImage (named: "\(allUsers[i].name)_\(i + 1)")!)
        }
        dataSource = array
    }

}

// MARK: KolodaViewDelegate

extension ViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        let position = cardView.currentCardIndex
        for i in 1...4 {
            dataSource.append(UIImage(named: "Card_like_\(i + 1)")!)
        }
        cardView.insertCardAtIndexRange(position..<position + 4, animated: true)
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
        
        name.text = allUsers[index].name
        name.font = name.font.withSize(30)
        instrument.text = allUsers[index].instrument
        instrument.font = instrument.font.withSize(20)
        
        v.addSubview(image)
        v.addSubview(name)
        v.addSubview(instrument)
        
        return v
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}

