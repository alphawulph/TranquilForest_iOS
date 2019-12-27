//
//  MainTableViewController.swift
//  TranquilForest
//
//  Created by David Ritchie on 11/17/19.
//  Copyright © 2019 David Ritchie. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import os

class MainViewController: UIViewController, FBAdViewDelegate {
    @IBOutlet var adContainer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var playPauseButton: UIBarButtonItem!
    
    var adView: FBAdView?
    var altAdView: UIImageView?
    var soundItems: [SoundItem] = []
    var dataSource: SoundItemSource
    var audioController: AudioController
    var paused: Bool = false
    var timer: Timer?
    
    required init?(coder aDecoder: NSCoder) {
        dataSource = SoundItemSource(soundItems: soundItems)
        audioController = AudioController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildAdView()
        
        if let data = NSDataAsset(name: "SoundItems")?.data {
            let soundItemsText = String(data: data, encoding: .utf8)
            
            soundItems = try! JSONDecoder().decode([SoundItem].self, from: soundItemsText!.data(using: String.Encoding.utf8)!)
            
            dataSource = SoundItemSource(soundItems: soundItems)
            tableView.dataSource = dataSource
        }

        audioController = AudioController()
}
    
    func buildAdView(){
        adView = FBAdView(placementID: "2352373935076505_2352376368409595", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        //"IMG_16_9_LINK#2352373935076505_2352376368409595"
        
        adView?.frame = CGRect(x:0, y:0, width:300, height:50)
        adView?.delegate = self
        adView?.loadAd()
        
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true, block: { timer in
            self.adView?.loadAd()
        })
    }
    
    func adViewDidLoad(_ adView: FBAdView){
        clearAdContainer()
        adContainer.addSubview(adView)
        
        os_log("Ad Loaded", log: OSLog.default, type: .info)
    }
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        createYoutubeBanner()
        
        os_log("%{PUBLIC}@)", log: OSLog.default, type: .error, error.localizedDescription)
    }
    
    func createYoutubeBanner(){
        clearAdContainer()
        if let bannerAd = UIImageView(image: UIImage(named: "yt-banner")) as UIImageView? {
            altAdView = bannerAd
            adContainer.addSubview(altAdView!)
            
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.handleYoutubeTap))
            adContainer.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleYoutubeTap(_ sender:Any){
       openURL(url: "https://www.youtube.com/c/TranquilForestRelaxationVideos")
    }

    func clearAdContainer() {
        for view in adContainer.subviews {
            view.removeFromSuperview()
        }
        
        adContainer.gestureRecognizers?.removeAll()
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
