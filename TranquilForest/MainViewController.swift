//
//  MainTableViewController.swift
//  TranquilForest
//
//  Created by David Ritchie on 11/17/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import UIKit
import os

class MainViewController: UIViewController {
    @IBOutlet var adContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playPauseButton: UIBarButtonItem!
    
    var altAdView: UIImageView?
    var soundItems: [SoundItem]?
    var dataSource: SoundItemSource?
    var audioController: AudioController
    var paused: Bool = false
    var timer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        //dataSource = SoundItemSource(soundItems: soundItems)
        audioController = AudioController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = NSDataAsset(name: "SoundItems")?.data {
            do{
                let soundItemsText = String(data: data, encoding: .utf8)
                
                soundItems = try JSONDecoder().decode([SoundItem].self, from: soundItemsText!.data(using: String.Encoding.utf8)!)
                
                dataSource = SoundItemSource(soundItems: soundItems!)
                tableView.dataSource = dataSource
            } catch {
                os_log("%{PUBLIC}@", log: OSLog.default, type: .error, "Unexpected error: \(error).")
                
            }
        }
        
        audioController = AudioController()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        paused.toggle()
        NotificationCenter.default.post(name: .cmdPausePlaying, object: self, userInfo: ["pause": paused])
        
        if paused {
            playPauseButton.image = UIImage(systemName: "play.circle.fill")
        }
        else {
            playPauseButton.image = UIImage(systemName: "pause.circle.fill")
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .cmdPausePlaying, object: self, userInfo: [:])
    }

    func openURL(url: String) {
        if let requestUrl = URL(string: url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(requestUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(requestUrl)
            }
        }
    }
}
